#!/bin/bash

# === CONFIGURATION ===
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"
REMOTE_USER="your_ssh_user"
REMOTE_SERVER="server2_ip_or_hostname"
REMOTE_BACKUP_DIR="/backup/postgres"
RESTORE_DIR="/tmp/postgres_restore"

# Ensure restore directory exists
mkdir -p "$RESTORE_DIR"

# List available backups
echo "Fetching available PostgreSQL backups from Server 2..."
ssh "$REMOTE_USER@$REMOTE_SERVER" "ls -lh $REMOTE_BACKUP_DIR"

# Ask user for database and backup file
read -p "Enter the database name to restore: " DB_NAME
read -p "Enter the backup filename (e.g., mydb_backup_2025-03-27.sql.gz): " BACKUP_FILE

# Copy backup from Server 2
scp "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_BACKUP_DIR/$BACKUP_FILE" "$RESTORE_DIR/"

# Restore database
gunzip -c "$RESTORE_DIR/$BACKUP_FILE" | PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USER" -h localhost -d "$DB_NAME"

echo "PostgreSQL database $DB_NAME restored successfully!"
