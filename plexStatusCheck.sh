#!/bin/sh

logFile="/opt/plexStatusCheck.log"
logData=$(cat "$logFile")
echo $logData

#Check the status of the primary Plex server by looking for "plex-logo" in the output of the curl command
plexStatus=`curl https://[INSERT HOST HERE]:32400/web/index.html -s -k | grep plex-logo | wc -l`

#Restart the local Plex server to pickup database changes sync'd from the primary if the curl fails to return a count of 1
if [ $plexStatus -eq 0 ]
        then
                if [ "$logData" =  "Secondary Restarted" ]
                        then
                                echo `date`
                                echo "[PLEX FAILOVER] Plex already restarted on the secondary instance. No action to take."
                fi
fi

if [ $plexStatus -eq 0 ]
        then
                if [ "$logData" = "" ]
                        then
                                echo `date` 
                                echo "[PLEX CRITICAL] Plex is down on the primary instance. Restarting Plex on the secondary to pickup database changes."
                                `service plexmediaserver restart`
                                echo "Secondary Restarted" > $logFile
                                curl -X POST -H 'Content-type: application/json' --data '{"text":"[PLEX FAILOVER] Plex Server Failover Event!"}' https://hooks.slack.com/services/[INSERT TOKEN HERE]
                fi
fi

if [ $plexStatus -eq 1 ]
        then
                if [ "$logData" = "Secondary Restarted" ]
                        then
                                echo `date`
                                echo "[PLEX FAILOVER OK] Plex is now available on the primary node once again."
                                curl -X POST -H 'Content-type: application/json' --data '{"text":"[PLEX FAILOVER OK] Plex Server Primary OK!"}' https://hooks.slack.com/services/[INSERT TOKEN HERE]
                                `cat /dev/null` > $logFile
                fi
fi

if [ $plexStatus -eq 1 ]
        then
                if [ "$logData" = "" ]
                        then
                                echo `date` 
                                echo "[PLEX OK] Plex up and responding on the primary. No action to take."
                        `cat /dev/null` > $logFile
                fi
fi
