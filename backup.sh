#!/bin/bash
# Backup script

# Directory to store backups
BACKUP_DIR="/backup/dir/"

# Maximum number of backups to keep
MAX_BACKUPS=4

# Log file location
LOG_LOC="/var/log/custom-backup-script.log"

# File containing list of directories to exclude from backup
EXCLUDE_FILE="/backupscriptdir/exclude_dirs.conf"

# File containing list of directories to backup
INCLUDE_FILE="/backupscriptdir/include_dirs.conf"

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Function to perform backup
function perform_backup {
    # Get timestamp for backup file name
    timestamp=$(date "+%Y%m%d-%H%M%S")

    # Create backup file
    backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"
    tar --exclude-from="$EXCLUDE_FILE" -czf "$backup_file" -T "$INCLUDE_FILE" 2>> "$LOG_LOC"

    # Set owner and group of backup file
    chown www-data:www-data "$backup_file"

    # Remove oldest backup files if more than MAX_BACKUPS exist
    num_backups=$(ls -1 "$BACKUP_DIR"/*.tar.gz | wc -l)
    if [ "$num_backups" -gt "$MAX_BACKUPS" ]; then
        num_to_remove=$((num_backups - MAX_BACKUPS))
        ls -1tr "$BACKUP_DIR"/*.tar.gz | head -n $num_to_remove | xargs rm -f
    fi

    # Update Nextcloud files
    echo "Changing owners and updating Nextcloud." >> "$LOG_LOC"
    cd /var/www/nextcloud/
    sudo -u www-data php occ files:scan --all >> "$LOG_LOC"
}

# Check that backup_dirs.conf exists and has content
if [ ! -s "$INCLUDE_FILE" ]; then
    echo "Create include_dirs.conf in /backupscript" >> "$LOG_LOC"
    exit 1
fi

# Check that exclude_dirs.conf exists
if [ ! -e "$EXCLUDE_FILE" ]; then
    echo "Create exclude_dirs.conf in /backupscript" >> "$LOG_LOC"
    exit 1
fi

# Perform backup
echo "Starting backup..." >> "$LOG_LOC"
perform_backup
echo "Backup complete at: $(date)" >> "$LOG_LOC"
