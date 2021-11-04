#!/bin/sh

plexToken="[INSERT PLEX TOKEN HERE]"

#Check the status of the primary Plex server by looking for "<MediaContainer" in the output of the curl command
plexPrimaryStatus=`curl https://[INSERT LOCAL PLEX HOST HERE]:32400/status/sessions?X-Plex-Token=$plexToken -s -k | grep "<MediaContainer" | wc -l`
rsyncStatus=`ps -ef | grep rsync | grep -v grep | grep plex | wc -l`

if [ $plexPrimaryStatus -eq 0 ]
        then
                echo `date` "[PLEX CRITICAL] Plex is down on the primary instance. NOT syncing changes to the secondary."
fi

if [ $plexPrimaryStatus -eq 1 ]
        then
                if [ $rsyncStatus -gt 2 ]
                        then
                                echo `date` "[RSYNC ERROR] Multiple ($rsyncStatus) concurrent rsync jobs have been discovered. Aborting current transfer."
                        fi
                if [ $rsyncStatus -eq 0 ]
                        then
                        echo `date` "[PLEX OK] Plex is up and responding on the primary node. Syncing changes to the secondary."
                        echo `date` "[RSYNC STATUS] $rsyncStatus jobs have been discovered."
                        nice -n 19 ionice -c 2 -n 7 sshpass -p "[INSERT SSH PASSWORD HERE]" rsync -uav --delete-during --exclude='Library/Application Support/Plex Media Server/Cache/Transcode/Sync+' /var/lib/plexmediaserver/* [INSERT REMOTE HOST HERE]:/var/lib/plexmediaserver
                fi
fi
