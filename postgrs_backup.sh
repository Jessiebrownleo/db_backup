#!/bin/bash

# === CONFIGURATION ===
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"
BACKUP_DIR="/tmp/postgres_backups"
TIMESTAMP=$(date +"%Y-%m-%d")
REMOTE_USER="your_ssh_user"
REMOTE_SERVER="server2_ip_or_hostname"
REMOTE_BACKUP_DIR="/backup/postgres"
RETENTION_DAYS=7

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Get list of PostgreSQL databases (excluding system databases)
DATABASES=$(psql -U "$DB_USER" -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

for DB in $DATABASES; do
    BACKUP_FILE="$BACKUP_DIR/${DB}_backup_${TIMESTAMP}.sql.gz"
    PGPASSWORD="$DB_PASSWORD" pg_dump -U "$DB_USER" -h localhost -d "$DB" | gzip > "$BACKUP_FILE"
    scp "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_BACKUP_DIR/"
done

# Delete old backups on Server 2
ssh "$REMOTE_USER@$REMOTE_SERVER" "find $REMOTE_BACKUP_DIR -name '*_backup_*.sql.gz' -type f -mtime +$RETENTION_DAYS -exec rm -f {} \;"

echo "PostgreSQL backup completed!"
