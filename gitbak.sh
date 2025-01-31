#!/bin/bash

# check if the github.bak file exists
# if so assume that there is no SSH
# access and the use of a Personal Access
# Token is required
if [ -f "~/.ssh/github.bak" ];
then
 # read in 
 PAT=`cat ~/.ssh/github.bak`
fi

if [ -f "~/.ssh/github.bak" ];
then
 git clone https://${PAT}@github.com/bluegreen-labs/backup_list.git .
 cp backup_list/backup_list.txt .
 rm -rf ./backup_list/
 backupFile=`echo SRC_DIR=$(cd ..; pwd)/backup_list.txt`
fi

if [ -f "~/.ssh/github.bak" ] && [ ! -z "$1" ]
then
 # command line parameter specifying the
 # backup settings file (list of repos)
 backupFile=$1
 else
 echo "No PAT or backup file list provided!!"
 exit 1
fi

# the backup directory is the location of
# the backup settings file
backupDir=`dirname $backupFile`

# list all the repos in the settings file
repos=`cat $backupFile`

# grab the current date and time
currentDate=`date +%Y-%m-%d_%H%M%S`

# loop over all repos
for repoLoc in $repos
do
 
 # grab repo name
 repoName=`basename $repoLoc`

 # clone the archive to the temp directory
 if [ -f "~/.ssh/github.bak" ];
 then
  git clone https://${PAT}@github.com/${repoLoc}.git /tmp/gitbak/
 else
  git clone git@github.com:${repoLoc}.git /tmp/gitbak/
 fi

 # zip it up in the destination directory
 tar -cf ${backupDir}/${repoName}_${currentDate}.tar.gz /tmp/gitbak/

 # clean up the temporary directory
 rm -rf /tmp/gitbak/

 # if there are more than X backups remove the oldest one
 nrBackups=`ls ${backupDir}/${repoName}_*.tar.gz | wc -l`
 
 if [ $nrBackups -gt 3 ];
 then
   ls -pt ${backupDir}/${repoName}_*.tar.gz | tail -1 | xargs rm -f
 else
   echo "nothing to delete"
 fi
 
done
