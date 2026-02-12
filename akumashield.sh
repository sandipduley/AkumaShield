#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FIX_MODE=false
ONLY_MODULE=""

# Load core libraries
source "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/logger.sh"

# ----------------------------------
# Root Enforcement
# ----------------------------------
if [[ "${EUID}" -ne 0 ]]; then
	log_critical "AkumaShield must be run as root."
	exit 1
fi

# ----------------------------------
# Argument Parsing
# ----------------------------------
while [[ $# -gt 0 ]]; do
	case "$1" in
	--fix)
		FIX_MODE=true
		shift
		;;
	--only)
		[[ -z "${2:-}" ]] && {
			log_critical "--only requires a module name"
			exit 1
		}
		ONLY_MODULE="$2"
		shift 2
		;;
	-L)
		LOG_ENABLED=true
		shift
		;;
	-h | --help)
		echo "Usage: ./akumashield.sh [--fix] [--only <module>] [-L]"
		echo
		echo "Options:"
		echo "  --fix            Automatically fix detected issues"
		echo "  --only <module>  Run specific module"
		echo "  -L               Enable logging to file"
		echo "  -h, --help       Show help"
		exit 0
		;;
	*)
		log_critical "Unknown argument: $1"
		exit 1
		;;
	esac
done

# ----------------------------------
# Module Auto-Discovery
# ----------------------------------

declare -A MODULE_MAP

discover_modules() {
	while IFS= read -r -d '' file; do
		module_name="$(basename "$file" .sh)"

		# shellcheck source=/dev/null
		source "$file"

		MODULE_MAP["$module_name"]="run_${module_name}_module"
	done < <(find "${SCRIPT_DIR}/modules" -type f -name "*.sh" -print0)
}

# ----------------------------------
# Module Execution
# ----------------------------------

run_modules() {
	if [[ -n "${ONLY_MODULE}" ]]; then
		if [[ -n "${MODULE_MAP[$ONLY_MODULE]:-}" ]]; then
			"${MODULE_MAP[$ONLY_MODULE]}"
		else
			log_critical "Module '${ONLY_MODULE}' not found."
			exit 1
		fi
	else
		for module in "${!MODULE_MAP[@]}"; do
			"${MODULE_MAP[$module]}"
		done
	fi
}

# ----------------------------------
# Banner
# ----------------------------------

print_banner() {
	echo -e "${BGreen}"
	echo "AkumaShield - Linux Audit & Hardening Framework"
	echo -e "${Reset}"
}

# ----------------------------------
# Execution Flow
# ----------------------------------

print_banner
init_logger
discover_modules
run_modules

log_info "Scan completed successfully."
