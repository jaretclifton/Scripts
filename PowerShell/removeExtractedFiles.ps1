# Clear all existing variable data from memory
Clear-Variable my* -Scope Global


# Get current date
$myNow = Get-Date

# Get shorthand date for output log
$myShortDate = Get-Date -Format g

# Define amount of hours
$myHours = "8"

# Define LastWriteTime parameter based on $Days
$myLastWrite = $myNow.AddHours(-$myHours)

# Set the input file to the log file in question
$myInputLogFile = "ENTERTHEUNCPATHTOYOURINPUTLOGFILE"

# Set the output file to log events to
$myOutputLogFile = "ENTERTHEUNCPATHTOYOUROUTPUTLOGFILE"


# Define the regular expression matching for the log file - 4 groups defined by parenthesis of which we care about group 3
$myRegexMatch = "(Extracting files) (\[)(.*)(\])"


# Look through the look using the regex and only output the full path including the file name
$myGetFileList = Select-string -Path $myInputLogFile -Pattern $myRegexMatch | Foreach-Object { $_.Matches[0].Groups[3].Value }

#Write-Output $myGetFileList
        
    
# Look for files with a last written time older than X hours (AddDays(-VALUE)
if ( $myGetFileList -ne $NULL)
    {
    $myFiles = Get-Item $myGetFileList | Where-Object { $_.LastWriteTime -le $myLastWrite }
    }


# Step through each file and delete it
foreach ($File in $myFiles) 
    {
    if ($File -ne $NULL)
        {
        Add-Content -Path $myOutputLogFile -Value "[$myShortDate] Deleted file: $File"
        Remove-Item $File.FullName | out-null
        }
    else
        {
        Write-Host "No more files to delete!" -foregroundcolor "Green"
        }
    }
