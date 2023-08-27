#!/system/bin/sh

# Wait until the 'sys.boot_completed' property is set before proceeding
until [ "$(getprop init.svc.bootanim)" = "stopped" ]; do
  sleep 10
done

# speed / speed-profile / bg-dexopt
ETC="disabled"
MODE="bg-dexopt"
PROPFILE="/data/adb/modules/Etc/module.prop"
LOG_FILE="/data/adb/modules/Etc/etc.log"
CURRENT_TIME=$(date +"%I:%M %P")

# Clear the log file or create it if it doesn't exist
> "$LOG_FILE"

# Function to log messages to the file
log() {
    echo "$1" >> "$LOG_FILE"
}

# Log starting configuration
log "Starting configuration"
log "mode = [$MODE]"
log "$(date)"
log "----------------------------------------------------------------------------"

sed -Ei "s/^description=(\[.*][[:space:]]*)?/description=[ 😍 ${MODE} is in progress!!! ] /g" "$PROPFILE"

# Loop through each installed app and compile using bg-dexopt
# include system apps
include="false"

if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  RESET='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  RESET=''
fi

compile_package() {
  app="$1"
  result=$(cmd package compile -r "$MODE" "$app") && result="${GREEN}${result}${RESET}"
  [ -t 1 ] && echo -e "${YELLOW}${app}${RESET} | ${result}" || log "${app} | ${result}"
}

optimization() {
  if [ "${include}" != "true" ]; then
    pm list packages -3 | cut -f2 -d':' | while IFS= read -r app; do
      compile_package "$app"
    done
  else
    pm list packages | cut -f2 -d':' | while IFS= read -r app; do
      compile_package "$app"
    done
  fi
}

my_device() {
  # disable find my device
  pm disable "com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver" > /dev/null 2>&1
}

description() {
  sed -Ei "s/^description=(\[.*][[:space:]]*)?/description=[ $CURRENT_TIME | 🤩 mode: $MODE !!!  ] /g" "$PROPFILE"
}

my_device
if [ "${ETC}" = "disabled" ];then
  log "service etc disable"
  sed -Ei "s/^description=(\[.*][[:space:]]*)?/description=[ $CURRENT_TIME | 🤩 ETC: service $ETC !!!  ] /g" "$PROPFILE"
else
  optimization
  description
fi

log "----------------------------------------------------------------------------"
log "Configuration Finished"
