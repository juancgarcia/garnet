source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg'

# >>>>>>>>>>>>>>>>>>>>>>>>>
# remaining gems are sorted alphabetically
gem 'ancestry'
gem 'bcrypt' # Use ActiveModel has_secure_password
gem 'cancancan'
gem 'coderay'
gem 'coffee-rails', '~> 4.1.0' # Use CoffeeScript for .coffee assets and views
gem 'figaro'
gem 'font-awesome-rails'
gem 'httparty'
gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'octokit'
gem 'redcarpet' # use redcarpet for markdown support
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets


group :production do
  # WORKAROUND: had difficulties debugging with unicorn, reverted to Webrick for dev
  gem 'unicorn-rails'
end

group :development, :test do
  gem 'awesome_print'
  gem 'capybara'
  gem 'launchy' # for capybara, save_and_open_page
  gem 'newrelic_rpm' # http://newrelic.com/ruby
  gem 'pry-byebug' # Call 'binding.pry', 'debugger', or 'byebug' to debug
  gem 'rspec-rails', '~> 3.0'
  gem 'web-console', '~> 2.0' # Access an IRB console on exception pages or by using <%= console %> in views
end

group :development do
  gem 'sdoc', '~> 0.4.0', group: :doc   # bundle exec rake doc:rails generates the API under doc/api.
  # gem 'spring'
end
