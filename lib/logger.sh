#!/usr/bin/env bash

LOG_ENABLED=false
LOG_FILE=""

init_logger() {
	if [[ "${LOG_ENABLED}" == true ]]; then
		mkdir -p "${SCRIPT_DIR}/logs"
		LOG_FILE="${SCRIPT_DIR}/logs/$(date +%Y-%m-%d).log"

		# Overwrite same-day log
		: >"${LOG_FILE}"

		# Redirect:
		# - Terminal keeps colors
		# - Log file strips ANSI escape sequences
		exec > >(tee >(sed -r 's/\x1B\[[0-9;]*[mK]//g' >>"${LOG_FILE}")) 2>&1
	fi
}

write_log() {
	local level="$1"
	local message="$2"

	local timestamp
	timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

	echo "[${timestamp}] [${level}] ${message}"
}

log_info() {
	write_log "INFO" "$1"
}

log_warn() {
	write_log "WARN" "$1"
}

log_critical() {
	write_log "CRITICAL" "$1"
}

log_secure() {
	write_log "SECURE" "$1"
}

log_fixed() {
	write_log "FIXED" "$1"
}
