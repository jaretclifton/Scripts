#!/bin/sh

while true
do

        logFile="/opt/logs/plexStatusCheck.log"
        plexToken="[INSERT PLEX TOKEN HERE]"
        plexRunning=`systemctl show -p SubState --value plexmediaserver`
        slackWebHook="https://hooks.slack.com/services/[INSERT SLACK WEBHOOK TOKEN HERE]"
        hostName=`hostname`

        #Check the status of the primary and secondary Plex servers by looking for "<MediaContainer" in the output of the curl command
        plexPrimaryStatus=`curl --retry 2 --retry-all-errors --connect-timeout 3 http://[INSERT LOCAL PRIMARY PLEX SERVER URL HERE]:32400/identity -s | grep "<MediaContainer" | wc -l`
        plexSecondaryStatus=`curl --retry 2 --retry-all-errors --connect-timeout 3 http://[INSERT LOCAL SECONDARY PLEX SERVER URL HERE]:32400/identity -s | grep "<MediaContainer" | wc -l`

        #Restart the local Plex server to pickup database changes sync'd from the primary if the curl fails to return a count of 1
        if [ $plexPrimaryStatus -eq 0 ]
                then
                        if [ $plexSecondaryStatus -eq 0 ]
                                then
                                        if [ "$plexRunning" = "running" ]
                                        then
                                                echo `date` "[PLEX FAILOVER] Plex already restarted on $hostName. No action to take." | tee -a $logFile
                                        fi
                                        if [ "$plexRunning" != "running" ]
                                        then
                                                echo `date` "[PLEX CRITICAL] Plex is down on the primary and secondary nodes. Restarting Plex on $hostName to pickup database changes." | tee -a $logFile
                                                systemctl restart plexmediaserver.service
                                                echo `date` "[PLEX RESTARTED] Plex has been restarted on $hostName." | tee -a $logFile
                                                plexRunningRestart=`systemctl show -p SubState --value plexmediaserver`
                                                        if [ "$plexRunningRestart" = "running" ]
                                                        then
                                                                curl -s -X POST -H 'Content-type: application/json' --data "{\"text\":\"Plex Server Failover Event! $hostName is now active.\"}" $slackWebHook
                                                        fi
                                        fi

                        fi
        fi

        #Stop the local plex server if it's running and the primary or secondary is reachable
        if [ $plexPrimaryStatus -eq 1 ]
                then
                        if [ "$plexRunning" = "running" ]
                                then
                                        echo `date` "[PLEX FAILOVER OK] Plex is now available on the primary node once again. Shutting down Plex on $hostName" | tee -a $logFile
                                        curl -s -X POST -H 'Content-type: application/json' --data '{"text":"Plex Server Primary OK!"}' $slackWebHook
                                        systemctl stop plexmediaserver.service
                        fi

                        if [ "$plexRunning" != "running" ]
                                then
                                        echo `date` "[PLEX OK] Plex up and responding on the primary. No action to take." | tee -a $logFile
                        fi
        fi
        if [ $plexSecondaryStatus -eq 1 ]
                then
                        if [ "$plexRunning" = "running" ]
                                then
                                        echo `date` "[PLEX FAILOVER OK] Plex is now available on the secondary node once again. Shutting down Plex on $hostName" | tee -a $logFile
                                        curl -s -X POST -H 'Content-type: application/json' --data '{"text":"Plex Server Secondary OK!"}' $slackWebHook
                                        systemctl stop plexmediaserver.service
                        fi

                        if [ "$plexRunning" != "running" ]
                                then
                                        echo `date` "[PLEX OK] Plex up and responding on the Secondary. No action to take." | tee -a $logFile
                        fi

        fi

sleep 5
done
