#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/lib/colors"
source "${SCRIPT_DIR}/modules/system/passwd"
source "${SCRIPT_DIR}/modules/system/shadow"

BANNER=$(
	cat <<-EOF

		 ▗▖ ▐                ▄▄ ▐    ▝      ▝▜    ▐  
		 ▐▌ ▐ ▗ ▗ ▗ ▗▄▄  ▄▖ ▐▘ ▘▐▗▖ ▗▄   ▄▖  ▐   ▄▟  
		 ▌▐ ▐▗▘ ▐ ▐ ▐▐▐ ▝ ▐ ▝▙▄ ▐▘▐  ▐  ▐▘▐  ▐  ▐▘▜  
		 ▙▟ ▐▜  ▐ ▐ ▐▐▐ ▗▀▜   ▝▌▐ ▐  ▐  ▐▀▀  ▐  ▐ ▐  
		▐  ▌▐ ▚ ▝▄▜ ▐▐▐ ▝▄▜ ▝▄▟▘▐ ▐ ▗▟▄ ▝▙▞  ▝▄ ▝▙█  

	EOF
)
echo -e "${Red}${BANNER}${Reset}\n"
echo -e "${Cyan}AkumaShield${Reset} — not yet another one-off hardening script"
echo -e "${Cyan}Author${Reset}: Sandip Duley\n"

# Global execution flags controlling help display, run mode, fixing behavior, safety, output formatting, and user interaction
SHOW_HELP=false
RUN_MODE=false
FIX_MODE=false
DRY_RUN=false
NO_COLOR=false
ONLY_MODULES=""

# Parsing Arguments
for arg in "$@"; do
	case "$arg" in
	-h | --help) SHOW_HELP=true ;;

	--audit) RUN_MODE=true ;;

	--fix) RUN_MODE=true FIX_MODE=true ;;

	--dry-run) DRY_RUN=true ;;

	--no-color) NO_COLOR=true ;;

	--only=*) ONLY_MODULES="${arg#*=}" ;;
	*)
		echo "[!] Unknown option: $arg"
		echo "Use -h or --help to see available options."
		exit 1
		;;
	esac
done

# Export global execution flags and module filters for use across all AkumaShield modules
export FIX_MODE
export DRY_RUN
export NO_COLOR
export AUTO_YES
export ONLY_MODULES

print_help() {
	cat <<EOF
Usage: sudo ./akumashield.sh [OPTIONS]

Execution modes:
  --audit              Run security audit only (no changes)
  --fix                Run audit and automatically fix safe issues

Options:
  --dry-run            Show what would be fixed (no changes)
  --only=MODULES       Run only specific modules (comma-separated)
                       Example: --only=passwd,shadow
  --no-color           Disable colored output
  -h, --help           Show this help message

Examples:
 sudo ./akumashield.sh --audit
 sudo ./akumashield.sh --fix --yes
 sudo ./akumashield.sh --fix --dry-run
 sudo ./akumashield.sh --audit --only=passwd

EOF
}

if [[ "${SHOW_HELP}" == true ]]; then
	print_help
	exit 0
fi

if [[ "${RUN_MODE}" != true ]]; then
	echo "[!] No execution mode selected."
	echo "Use -h or --help to see available options."
	exit 1
fi
