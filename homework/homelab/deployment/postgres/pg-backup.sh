#!/bin/bash

# Required ENVs TODO: Add check
# TG_HOST
# OWNER_ID
# ASTOLFO_BOT_KEY
# 
# POSTGRES_USER
# POSTGRES_PASSWORD
# POSTGRES_DB

# --- Configuration ---
POSTGRES_CONTAINER_NAME="systemd-portable-postgres"

# Backup file settings
TIMESTAMP=$(date +%Y%m%d%H%M%S)
# BACKUP_DIR="/tmp/postgres_backups" # Temporary local storage for the backup file
BACKUP_DIR="${HOME}/postgres_backups" # Temporary local storage for the backup file
BACKUP_FILE="${POSTGRES_DB}_${TIMESTAMP}.dmp.gz" # .dmp for custom format, .gz for gzipped
FULL_BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# Adjust based on your rclone config
RCLONE_REMOTE_NAME="gdrive"
RCLONE_REMOTE_PATH="watgbridge/backups/${POSTGRES_DB}"

# Retention settings (on remote)
RETENTION_DAYS=7

HOSTNAME=$(hostname)

# --- Functions ---
log() {
    echo "$1"
}

send_notification() {
    curl "${TG_HOST}/bot${ASTOLFO_BOT_KEY}/sendMessage" \
         -d chat_id="${OWNER_ID}"\
         -d text="$1: $2" >/dev/null
}

# --- Main Script ---
log "Starting PostgreSQL backup for database: ${POSTGRES_DB}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR" || { log "Error: Failed to create backup directory ${BACKUP_DIR}"; send_notification "PostgreSQL Backup FAILED on $HOSTNAME" "Failed to create backup directory."; exit 1; }

# Perform pg_dump inside the Docker container and compress it
log "Dumping database '${POSTGRES_DB}' from container '${POSTGRES_CONTAINER_NAME}'..."
sudo podman exec -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" "$POSTGRES_CONTAINER_NAME" \
    pg_dump \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    --format=c \
    --blobs \
    --clean \
    --if-exists \
    | gzip > "$FULL_BACKUP_PATH"

if [ $? -ne 0 ]; then
    log "Error: pg_dump failed."
    send_notification "PostgreSQL Backup FAILED on $HOSTNAME" "pg_dump failed for ${POSTGRES_DB} on ${POSTGRES_CONTAINER_NAME}. Check logs for details."
    rm -f "$FULL_BACKUP_PATH" # Clean up partial file
    exit 1
fi

log "pg_dump completed successfully. Local file: ${FULL_BACKUP_PATH}"

# Upload to remote storage using rclone
log "Uploading ${BACKUP_FILE} to ${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_PATH}..."
rclone copy "$FULL_BACKUP_PATH" "$RCLONE_REMOTE_NAME:$RCLONE_REMOTE_PATH"

if [ $? -ne 0 ]; then
    log "Error: rclone upload failed."
    send_notification "PostgreSQL Backup FAILED on $HOSTNAME" "rclone upload failed for ${POSTGRES_DB} to ${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_PATH}. Check logs for details."
    rm -f "$FULL_BACKUP_PATH"
    exit 1
fi

log "Upload completed successfully."

# Clean up local temporary file
log "Cleaning up local backup file: ${FULL_BACKUP_PATH}"
rm -f "$FULL_BACKUP_PATH"

# Apply retention policy on remote storage
log "Applying retention policy: keeping backups for ${RETENTION_DAYS} days."
# rclone doesn't have a direct "delete older than X days" for specific paths.
# A common approach is to use 'rclone lsjson' and then delete.
# For simplicity and robustness, it's often better to rely on lifecycle policies if your cloud provider supports them (e.g., S3).
# Alternatively, you can list and delete old files:
# Example for S3-compatible:
# find_old_backups_command="rclone lsjson ${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_PATH} --min-age ${RETENTION_DAYS}d"
# for_deletion_files=$(eval $find_old_backups_command | jq -r '.[] | .Path')
# if [ -n "$for_deletion_files" ]; then
#     log "Deleting old backups:"
#     echo "$for_deletion_files" | while read -r old_file; do
#         log "  Deleting $old_file"
#         rclone delete "${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_PATH}/${old_file}"
#     done
# else
#     log "No old backups found to delete."
# fi

# A simpler and safer retention for rclone is usually done with a dedicated cleanup script or cloud provider's lifecycle rules.
# For this script, we'll just log a placeholder.
log "Remote retention policy for ${RETENTION_DAYS} days should be handled by cloud provider's lifecycle rules or a separate cron job running 'rclone delete' based on timestamps."


log "PostgreSQL backup for ${POSTGRES_DB} completed successfully."
send_notification "PostgreSQL Backup SUCCESS on $HOSTNAME" "Backup for ${POSTGRES_DB} completed successfully to ${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_PATH}/${BACKUP_FILE}."

