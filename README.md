# Database Backup and Restore Scripts

## Overview
This project provides scripts for **automated daily backup and restore** of:
- MySQL databases
- PostgreSQL databases

## Backup Storage
- Backups are stored in `/backup/mysql` and `/backup/postgres` on **Server 2**.
- Each database is backed up **separately** and named as:
  ```
  <database>_backup_<YYYY-MM-DD>.sql.gz
  ```

## Scripts

| Script                 | Description |
|------------------------|-------------|
| `mysql_backup.sh`     | Backs up all MySQL databases and transfers them to Server 2. |
| `postgres_backup.sh`  | Backs up all PostgreSQL databases and transfers them to Server 2. |
| `mysql_restore.sh`    | Restores a selected MySQL database from a backup. |
| `postgres_restore.sh` | Restores a selected PostgreSQL database from a backup. |

## How to Use

### 1️⃣ Backup
Run:
```bash
./mysql_backup.sh
./postgres_backup.sh
```

### 2️⃣ Restore
Run:
```bash
./mysql_restore.sh
./postgres_restore.sh
```
Then follow the prompts to **select a database** and restore it.

## Automate Backup
To schedule **daily backups at 2 AM**, add these to cron:
```bash
crontab -e
```
```bash
0 2 * * * /path/to/mysql_backup.sh
0 2 * * * /path/to/postgres_backup.sh
```

## Retention Policy
- **Backups older than 7 days are automatically deleted**.

## Support
For any issues, feel free to ask!

