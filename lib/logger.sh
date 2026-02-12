#!/usr/bin/env bash

# colors
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
CYAN="\033[36m"
RESET="\033[0m"

LOG_ENABLED=false
LOG_FILE=""

init_logger() {
	if [[ "${LOG_ENABLED}" == true ]]; then
		mkdir -p "${SCRIPT_DIR}/logs"
		LOG_FILE="${SCRIPT_DIR}/logs/$(date +%Y-%m-%d).log"

		: >"${LOG_FILE}"

		exec > >(tee >(sed -r 's/\x1B\[[0-9;]*[mK]//g' >>"${LOG_FILE}")) 2>&1
	fi
}

write_log() {
	local level="$1"
	local message="$2"
	local timestamp
	local color=""

	timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

	case "$level" in
	INFO) color="$BLUE" ;;
	SUCCESS) color="$GREEN" ;;
	SECURE) color="$GREEN" ;;
	WARN) color="$YELLOW" ;;
	CRITICAL) color="$RED" ;;
	FIXED) color="$CYAN" ;;
	*) color="$RESET" ;;
	esac

	echo -e "${color}[${timestamp}] [${level}] ${message}${RESET}"
}

log_info() { write_log "INFO" "$1"; }
log_warn() { write_log "WARN" "$1"; }
log_critical() { write_log "CRITICAL" "$1"; }
log_secure() { write_log "SECURE" "$1"; }
log_fixed() { write_log "FIXED" "$1"; }
log_success() { write_log "SUCCESS" "$1"; }
