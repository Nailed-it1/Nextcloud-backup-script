This script is a backup script that uses the `tar` command to create compressed backup files of specified directories. The backup files are saved in a specified backup directory, and older backups are deleted once the number of backups in the directory exceeds a specified maximum.

To use the script, you need to create two configuration files: `backup_dirs.conf` and `exclude_dirs.conf`.

In the `backup_dirs.conf` file, you should list the directories you want to backup, one directory path per line.

In the `exclude_dirs.conf` file, you should list the directories (or files) you want to exclude from the backup, one directory path (or file path) per line.

You should then specify the backup directory, the maximum number of backups to keep, and the log file location in the script. Once you have made any necessary changes to the script, you can run it with the command `bash /path/to/backup_script.sh`.

The script will then perform a backup of the specified directories, excluding any directories or files listed in the `exclude_dirs.conf` file, and saving the backup file in the specified backup directory. The script will also delete older backups if the number of backups in the backup directory exceeds the maximum number specified, and will update Nextcloud files.

The script will output information about the backup process to the specified log file.
