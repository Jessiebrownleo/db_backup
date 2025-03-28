#!/bin/bash
# Configuration
SOURCE="/path/to/important/data"
DEST="/path/to/backup/location"
LOG_FILE="/var/log/backup_script.log"
ENCRYPTION_KEY="/path/to/encryption.key"
MAX_BACKUPS=7
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$DEST/backup_$TIMESTAMP.tar.gz"
# Function: Log messages
echo_log() {
 echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a $LOG_FILE
}
# Function: Perform cleanup
cleanup_old_backups() {
 find "$DEST" -name "backup_*.tar.gz" -mtime +$MAX_BACKUPS -exec rm {} \;
}
# Start Backup
echo_log "Starting backup…"
if tar -czf "$BACKUP_FILE" "$SOURCE"; then
 echo_log "Backup created successfully: $BACKUP_FILE"
 openssl enc -aes-256-cbc -salt -in "$BACKUP_FILE" -out "$BACKUP_FILE.enc" -pass file:"$ENCRYPTION_KEY" && rm "$BACKUP_FILE"
 echo_log "Backup encrypted."
else
 echo_log "Backup failed!"
 exit 1
fi
# Cleanup Old Backups
cleanup_old_backups
echo_log "Backup process completed."
exit 0