# Overview
A random collection of scripts to help admin things mostly related to Plex.


### Primary/Secondary HA
Scripts to help perform failover operations between a primary and secondary Plex server.


- plexSyncChanges.sh
  - Use rsync's "update" functionality to replicate changes from the primary Plex server to the secondary including deletions.
- plexStatusCheck.sh
  - Bash script to monitor the primary node from the secondary and take action if the primary fails to respond correctly.
- deleteSyncedItems.sh
  - Bash script to look for all transcoded items in the Sync+ folder that are older than 2 days and delete them.


### Torrent File Management
Scripts to aid in handling torrent downloads after successful download completion.

- removeExtractedFiles.ps1
  - PowerShell script to look for items that have been extracted from torrent downloads that are 8 hours old or older and delete them. This still leaves the torrent and it's files in place for seeding.


### Ombi Request Tool
Scripts related to managing actions from Ombi.

- ombiDBBackup.sh
  - Bash script to automate backup jobs of the Ombi database since this functionality is not included in the application.
- ombiBackupCleanup.sh
  - Bash script to delete old Ombi DB backups.
