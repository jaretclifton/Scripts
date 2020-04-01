#!/bin/sh

plexToken="[INSERT PLEX TOKEN HERE]"

#Check the status of the primary Plex server by looking for "<MediaContainer" in the output of the curl command
plexPrimaryStatus=`curl https://[INSERT LOCAL PLEX HOST HERE]:32400/status/sessions?X-Plex-Token=$plexToken -s -k | grep "<MediaContainer" | wc -l`

if [ $plexPrimaryStatus -eq 0 ]
        then
                echo `date` "[PLEX CRITICAL] Plex is down on the primary instance. NOT syncing changes to the secondary."
fi

if [ $plexPrimaryStatus -eq 1 ]
        then
                sshpass -p "[INSERT SSH PASSWORD HERE]" rsync -uav --delete --exclude='Library/Application Support/Plex Media Server/Cache/Transcode/Sync+' /var/lib/plexmediaserver/* [INSERT SECONDARY PLEX HOST HERE]:/var/lib/plexmediaserver
                echo `date` "[PLEX OK] Plex is up and running on the primary node. Syncing changes to the secondary."
fi
