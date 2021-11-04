#!/bin/bash

latestAvailableVersion=`curl -s https://github.com/Ombi-app/Ombi/releases | grep linux-x64.tar.gz | head -n1 | awk -F/ '{print $6}'`
currentVersion=`cat /root/lastDownloadedVersion.log`

if [ $latestAvailableVersion != $currentVersion ]
        then
        printf "\nVersion mismatch detected. Proceeding with update.\n\n"


        releaseVersion=`curl -s https://github.com/Ombi-app/Ombi/releases | grep linux-x64.tar.gz | head -n1 | awk -F/ '{print $6}'`
        releaseURL=https://github.com/Ombi-app/Ombi/releases/download/$releaseVersion/linux-x64.tar.gz
        date=`date '+%Y%m%d%H%M'`

        printf "Downloading latest version: $releaseVersion\n\n"
        wget -q $releaseURL -P /root

        printf "Creating backup of the existing Ombi install.\n\n"
        tar -czf /root/ombiBackups/ombiBackup.$date.tar.gz /opt/Ombi

        printf "\n\nCommencing upgrade.\n\n"
        printf "Stopping Ombi Service.\n\n"
        systemctl stop ombi
        printf "Extracting new version.\n\n"
        tar xzf /root/linux-x64.tar.gz --directory /opt/Ombi
        printf "Changing ownership to ombi:nogroup\n\n"
        chown ombi:nogroup -R /opt/Ombi
        printf "Starting Ombi service.\n\n"
        systemctl start ombi

        printf "Updating latest version download file.\n\n"
        printf $latestAvailableVersion > /root/lastDownloadedVersion.log
        mv /root/linux-x64.tar.gz /root/releaseBackups/$releaseVersion-linux-x64.tar.gz



else
        printf "\nExisting version is the same as current release. Aborting.\n\n"
fi
