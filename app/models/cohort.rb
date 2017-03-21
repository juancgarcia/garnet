class Cohort < ActiveRecord::Base
  has_many :events
  has_many :attendances, through: :events

  has_many :assignments
  has_many :submissions, through: :assignments

  has_many :memberships, dependent:  :destroy
  has_many :admin_memberships, -> { where(is_admin: true) }, class_name: 'Membership'
  has_many :nonadmin_memberships, -> { where(is_admin: false) }, class_name: 'Membership'
  alias_method :student_memberships, :nonadmin_memberships

  # through memberships
  has_many :admins, through: :admin_memberships, :source => :user
  alias_method :instructors, :admins
  has_many :nonadmins, through: :nonadmin_memberships, :source => :user
  alias_method :students, :nonadmins
  has_many :observations, through: :memberships
  has_many :users, through: :memberships

  # we use this to only show existing tags on the cohort tag form. The unique
  # is important becuase otherwise we'll get duplicates of tags
  has_many :existing_tags, -> {uniq},  through: :memberships, source: :tags

  belongs_to :course
  belongs_to :location

  scope :active, -> {where("end_date >= ?", Time.now)}
  scope :inactive, -> {where("end_date < ?", Time.now)}

  def has_admin? user
    self.admins.include?(user)
  end

  def add_admin(user)
    new_membership = self.memberships.create!(user: user, is_admin: true)
    user.reload # ensure user model reflects new membership
    return new_membership
  end

  def add_member(user, is_admin = false)
    new_membership = self.memberships.create!(user: user, is_admin: is_admin)
    user.reload # ensure user model reflects new membership
    return new_membership
  end

  def tags
    self.memberships.includes(:tags).map { |m| m.tags }.flatten.uniq
  end

  def self.to_csv(memberships)
    CSV.generate({}) do |csv|
      csv << ["User Name", "Percent Present", "Percent Tardy", "Percent Absent", "Percent HW Complete", "Percent HW Incomplete","Percent HW Missing"]
      memberships.each do |membership|
        csv << [
          membership.name,
          membership.percent_from_status(:attendances, :present),
          membership.percent_from_status(:attendances, :tardy),
          membership.percent_from_status(:attendances, :absent),
          membership.percent_from_status(:submissions, :complete),
          membership.percent_from_status(:submissions, :incomplete),
          membership.percent_from_status(:submissions, :missing)
        ]
      end
    end
  end

  def generate_events start_time, time_zone
    Time.use_zone time_zone do 
      end_time = end_date.in_time_zone
      current_time = start_date.in_time_zone.change(hour: start_time)
      days_in_cohort = (end_date - start_date).to_i

      day_count = 1

      # if the event exists and all attendance status are unmarked then nuke it to refill students
      self.events.select{|e|
        e.occurs_at.to_date > Date.today &&
        e.attendances.where(status: :unmarked).count > 0
      }.each{|e| e.destroy}

      days_in_cohort.times do |i|
        current_time += 1.day
        # if current day is a weekday .wday will return a number between 1-5
        if current_time.wday < 6 && current_time.wday > 0
          # sees if there's an event that has the same day and month as the current day
          if !self.events.any?{|event| event.occurs_at.to_date == current_time.to_date}
            self.events.create!(occurs_at: current_time, title: current_time.strftime("%B %d, %Y"))
          end
        end
      end
    end
    return self.events
  end
end
