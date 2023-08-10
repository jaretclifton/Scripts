settings {
        logfile = "/opt/logs/plexDirectoryRealtimeSync.log",
        statusFile = "/tmp/plexDirectorySync.stat",
        statusInterval = 1,
        nodaemon = false,
        maxProcesses = 1,
        inotifyMode = "CloseWrite or Modify",
        insist = true,
}



serverList = {
 "server1",
 "server2",
}


sourceList =
{
        "/var/lib/plexmediaserver",
}

for _, server in ipairs( serverList ) do
  for _, source in ipairs( sourceList ) do
          sync {
        default.rsyncssh,
        source = source,
        host = server,
        targetdir = "/var/lib/plexmediaserver/",
        delete = 'running',
        delay = 0,
        rsync = {
                compress = false,
                whole_file = false,
                update = true,
                inplace = true,
                checksum = true,
                owner = true,
                archive = true,
                update = true,
                perms = true,
                group = true,
                xattrs = true,
                copy_links = true,
        },

}

  end
end
