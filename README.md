# Github backup script

This is a basic github backup script. It backs up github repositories to the directory in which a text file resides with a list of respositories. The script should be run as cron job on a set schedule (daily, weekly or monthly). The last three backed up versions are kept for roll-back.

Repositories to be backed up should be listed in a text file as such:

```
bluegreen-labs/phenor
bluegreen-labs/MODISTools
...
```

This file should be called with the full path by the script/crontab entry.

```bash
# crontab settings for weekly backups on Monday at noon
0 12 * * 1 /home/user/bin/gitbak.sh /drive/backups/repositories.txt
```
This call will store zipped archived repositories in `/drive/backups` on weekly schedule. The last three backups are retained.

## Authorization

For private repositories authorization will be required. If no personal access token is provided (to be stored in `~/.ssh/github.bak` with read/write access, but no delete access) the existing ssh key on the system will work. Note that no additional passwords can be provided for the ssh key to function.
