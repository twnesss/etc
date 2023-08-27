#!/system/bin/sh

LOG_FILE="/data/adb/etc.log"

# Clear the log file or create it if it doesn't exist
> "$LOG_FILE"

# Function to log messages to the file
log() {
    echo "$1" >> "$LOG_FILE"
}

# Function to display messages before and after the action is performed
inform_user() {
    log "Deleting files with extension $1 in directory $2..."
}

# Function to delete files by extension in a specific directory
delete_files_with_extension() {
    find "$1" -type f \( -name "*.$2" -o -name "*.$3" -o -name "*.$4" \) -delete
}

rm_service() {
    if [ -f "/data/adb/service.d/etc_service.sh" ]; then
        rm -rf "/data/adb/service.d/etc_service.sh"
    fi
}
# Execute the function to remove files from the /data/app/ directory
inform_user "vdex, odex, dan art" "/data/app/"
delete_files_with_extension "/data/app/" "vdex" "odex" "art"

# Execute the function to delete files from the /data/dalvik-cache/ directory
inform_user "vdex, odex, dan art" "/data/dalvik-cache/"
delete_files_with_extension "/data/dalvik-cache/" "vdex" "odex" "art"

# remove services
rm_service