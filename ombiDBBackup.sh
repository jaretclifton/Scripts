#!/bin/sh
InputPath=/opt/Ombi/
OutputPath=/opt/ombiBackups/
InputFile=${InputPath}Ombi.db
Date=`date +%Y%m%d`
OutputFile=${OutputPath}Ombi.db${Date}

cp $InputFile $OutputFile
