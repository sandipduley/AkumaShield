#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/colors.sh"

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
echo -e "${Cyan}Author${Reset}: Sandip Duley"

SHOW_HELP=false
RUN_MODE=false
FIX_MODE=false
DRY_RUN=false
NO_COLOR=false
AUTO_YES=false
ONLY_MODULES=""

for arg in "$@"; do
	case "$arg" in
	-h | --help)
		SHOW_HELP=true
		;;
	--audit)
		RUN_MODE=true
		;;
	--fix)
		RUN_MODE=true
		FIX_MODE=true
		;;
	--dry-run)
		DRY_RUN=true
		;;
	--no-color)
		NO_COLOR=true
		;;
	--yes)
		AUTO_YES=true
		;;
	--only=*)
		ONLY_MODULES="${arg#*=}"
		;;
	*)
		echo "[!] Unknown option: $arg"
		echo "Use -h or --help to see available options."
		exit 1
		;;
	esac
done

export FIX_MODE
export DRY_RUN
export NO_COLOR
export AUTO_YES
export ONLY_MODULES

print_help() {
	cat <<EOF
Usage: ./akumashield.sh [OPTIONS]

Execution modes:
  --audit              Run security audit only (no changes)
  --fix                Run audit and automatically fix safe issues

Options:
  --dry-run            Show what would be fixed (no changes)
  --only=MODULES       Run only specific modules (comma-separated)
                       Example: --only=passwd,shadow
  --no-color           Disable colored output
  --yes                Skip confirmation prompts
  -h, --help           Show this help message

Examples:
  ./akumashield.sh --audit
  ./akumashield.sh --fix --yes
  ./akumashield.sh --fix --dry-run
  ./akumashield.sh --audit --only=passwd
EOF
}

if [[ "$SHOW_HELP" == true || "$#" -eq 0 ]]; then
	print_help
	exit 0
fi

if [[ "$RUN_MODE" != true ]]; then
	echo "[!] No execution mode selected."
	echo "Use -h or --help to see available options."
	exit 1
fi

#
# check_root_privilege() {
# 	if [ "${EUID}" -ne 0 ]; then
# 		echo -e "\n${Red}[X] AkumaShield must be run with sudo. Before running with elevated privileges, review the source code.${Reset}"
# 		exit 1
# 	else
# 		echo -e "\n${Green}[✓] Running as root...${Reset}"
# 	fi
# }
# check_root_privilege
#
# chmod +x "${SCRIPT_DIR}/modules/system/passwd.sh"
# source "${SCRIPT_DIR}/modules/system/passwd.sh"
