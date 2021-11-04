# Overview
A random collection of scripts to help admin things mostly related to Plex.


### Plex
Scripts to help perform failover operations between a primary and secondary Plex server.


- <a href="https://github.com/jaretclifton/Scripts/tree/master/Plex/plexSyncChanges.sh">plexSyncChanges.sh</a>
  - Bash script to use rsync's "update" functionality to replicate changes from the primary Plex server to the secondary including deletions.
- <a href="https://github.com/jaretclifton/Scripts/tree/master/Plex/plexStatusCheck.sh">plexStatusCheck.sh</a>
  - Bash script to monitor the primary node from the secondary and take action if the primary fails to respond correctly.
- <a href="https://github.com/jaretclifton/Scripts/tree/master/Plex/deleteSyncedItems.sh">deleteSyncedItems.sh</a>
  - Bash script to look for all transcoded items in the Sync+ folder that are older than 2 days and delete them.


### PowerShell
Scripts to aid in handling torrent downloads after successful download completion.

- <a href="https://github.com/jaretclifton/Scripts/tree/master/PowerShell/removeExtractedFiles.ps1">removeExtractedFiles.ps1</a>
  - PowerShell script to look for items that have been extracted from torrent downloads that are 8 hours old or older and delete them. This still leaves the torrent and it's files in place for seeding.


### Ombi
Scripts related to managing actions from the Ombi media request tool.

- <a href="https://github.com/jaretclifton/Scripts/tree/master/Ombi/ombiDBBackup.sh">ombiDBBackup.sh</a>
  - Bash script to automate backup jobs of the Ombi database since this functionality is not included in the application.
- <a href="https://github.com/jaretclifton/Scripts/tree/master/Ombi/ombiBackupCleanup.sh">ombiBackupCleanup.sh</a>
  - Bash script to delete old Ombi DB backups.
- <a href="https://github.com/jaretclifton/Scripts/tree/master/Ombi/autoOmbiUpgrade.sh">autoOmbiUpgrade.sh</a>
-   Bash script to fetch the latest pre-release version of Ombi, backup the current instance and then install the latest downloaded version.
