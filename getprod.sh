#!/bin/bash

file=`ssh git@gadc.space "ls -t /bak/*garnet* | head -1"`
scp git@gadc.space:$file $(basename $file)
rake db:drop:all
rake db:create
pg_restore -O -d garnet_development < $(basename $file)
rm $(basename $file)