#!/bin/bash
### custom-ops-watch-media

# directory to watch. this is for standard magento. This needs to change for
# wordpress, joomla, vbulletin, etc. Some sort of dynamic config?

watchdir=$(find /mnt/windows-fargate/ -maxdepth 3 -type d -name media)

#the log file
logfile=/var/log/webscale/inotify-watchdir.log


#kill any other running innotify scripts

pkill -9 inotify

#start watching directories
while : ; do
        inotifywait -m -r -e create,moved_to  $watchdir | while read path action file; do
                ts=$(date +"%C%y%m%d%H%M%S%N")
                echo "$ts :: file: $file :: $action :: $path" >> $logfile
                #send events to webscale
                sudo webscale-event post custom-ops-watch-media -d '{ "timestamp": "'"$ts"'" }'
                sudo docker build -t newwindowstest /mnt/windows-fargate/.
                sleep 120
        done
done
