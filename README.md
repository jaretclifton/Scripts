# Overview
A random collection of scripts to help admin things mostly related to Plex.


## Primary/Secondary HA
Scripts to help perform failover operations between a primary and secondary Plex server.


- rsyncChangedItemsCrontab
  - Use rsync's "update" functionality to replicate changes from the primary Plex server to the secondary including deletions.
- plexStatusCheck.sh
  - Use the plexStatusCheck.sh script to monitor the primary node from the secondary and take action if the primary fails to respond correctly.
- deleteSyncedItems.sh
  - Script to look for all transcoded items in the Sync+ folder that are older than 1 day and delete them.
