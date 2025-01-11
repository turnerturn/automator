#!/bin/bash
# This script is scheduled by crontab to execute periodically.

# Recursively find all PDF files in /opt/tas/documents/ where the file is updated or created within the last 90 days.
# For each file found:
# - Check if the file is currently being written to and skip if it is.
# - Check if the file has already been transmitted and skip if it has (if the file name is included in /opt/tas/data/transfer_pdfs_to_meow/transmitted_files.txt).
# - Transmit the file to the destination server via scp command.
# - If success: echo ${transmit-date} $file-name >> /opt/tas/data/transfer_pdfs_to_meow/transmitted_files.txt.
# - If failure: log the error message to /opt/tas/log/transfer_pdfs_to_meow.log.

# Directory and file paths
SOURCE_DIR="/workspaces/codespaces-blank/automator/scripts/pdf-sync/pdfs"
TRANS_DIR="/workspaces/codespaces-blank/automator/scripts/pdf-sync"
LOG_FILE="$TRANS_DIR/transfer_pdfs_to_meow.log"
TRANS_FILE="$TRANS_DIR/transmitted_files.txt"
DESTINATION_DIR="/workspaces/codespaces-blank/automator/scripts/pdf-sync/pdf-destination"

# Create necessary directories and files if they don't exist
mkdir -p "$TRANS_DIR"
touch "$TRANS_FILE"
touch "$LOG_FILE"

# Default log file size for rotation: 512000 bytes (500 KiB).
# The log file can generally hold between 2000-3000 log entries, depending on entry size.

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> "$LOG_FILE"
}

# Log rotation: Compress and archive the log file if it exceeds 512000 bytes.
rotate_log_file() {
    if [ -f "$LOG_FILE" ] && [ "$(stat --format=%s "$LOG_FILE")" -gt 512000 ]; then
        local archive_file="${LOG_FILE}_$(date +"%Y-%m-%d").gz"
        gzip -c "$LOG_FILE" > "$archive_file"
        > "$LOG_FILE" # Truncate the current log file
        log_message "Log file rotated and archived as $archive_file"
    fi
}

# Rotate the log file if needed
rotate_log_file

# Remove lines from transmitted_files.txt where transmitted date is older than 90 days (format: yyyy-mm-dd).
awk -v cutoff_date="$(date -d '90 days ago' +'%Y-%m-%d')" '$1 > cutoff_date {print}' "$TRANS_FILE" > "$TRANS_FILE.tmp" && mv "$TRANS_FILE.tmp" "$TRANS_FILE"

log_message "Old entries cleaned from $TRANS_FILE"

# Find all PDF files modified within the last 90 days
find "$SOURCE_DIR" -type f -name "*.pdf" -mtime -90 | while read -r file; do
    # Check if the file is currently being written to
    if lsof "$file" > /dev/null 2>&1; then
        log_message "Skipped $file (currently being written to)"
        continue
    fi

    # Check if the file has already been transmitted
    if grep -q "$file" "$TRANS_FILE"; then
        log_message "Skipped $file (already transmitted)"
        continue
    fi

    # TODO Transmit the file via scp
    if cp "$file" "$DESTINATION_DIR"; then
        # Convert date to format yyyy-mm-dd hh:mm:ss
        transmit_date=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$transmit_date $file" >> "$TRANS_FILE"
        log_message "Transmitted $file to $DESTINATION_DIR"
    else
        log_message "Failed to transmit $file"
    fi
done

log_message "Script execution completed."

# TODO Initialize the transmitted_files.txt file with current PDFs created/uploaded within the last 90 days.

## Acceptance Criteria
# - The transfer_pdfs_to_meow.txt file will be populated with the list of PDF files that exist at the time of installation.
#   This ensures only PDF files created after installation are transmitted.
# - The transfer_pdfs_to_meow.txt will contain a filename and the created date of the PDF file.
#   Entries will be removed from the file when the entry date is greater than 90 days old, keeping the file size manageable.
# - Only PDF files created more recently than 90 days will be transmitted.
# - The script will check that the PDF file is not currently being written to avoid transmitting partial files.
# - The script will keep a log of its operation in /opt/tas/log/transfer_pdfs_to_meow.log.
# - Files that fail to transmit will not be added to the transmitted file list, and the script will continue attempting to send them.
#   Errors will be logged to track these failures.
