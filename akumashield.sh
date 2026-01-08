#!/usr/bin/env bash
set -o errexit
set -o pipefail

# Resolve AkumaShield root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "${SCRIPT_DIR}/lib/colors"
# source "${SCRIPT_DIR}/lib/logger"

# Source modules
source "${SCRIPT_DIR}/modules/system/passwd"
source "${SCRIPT_DIR}/modules/system/shadow"
source "${SCRIPT_DIR}/modules/system/group"

# Banner
BANNER=$(
	cat <<'EOF'

 ▗▖ ▐                ▄▄ ▐    ▝      ▝▜    ▐
 ▐▌ ▐ ▗ ▗ ▗ ▗▄▄  ▄▖ ▐▘ ▘▐▗▖ ▗▄   ▄▖  ▐   ▄▟
 ▌▐ ▐▗▘ ▐ ▐ ▐▐▐ ▝ ▐ ▝▙▄ ▐▘▐  ▐  ▐▘▐  ▐  ▐▘▜
 ▙▟ ▐▜  ▐ ▐ ▐▐▐ ▗▀▜   ▝▌▐ ▐  ▐  ▐▀▀  ▐  ▐ ▐
▐  ▌▐ ▚ ▝▄▜ ▐▐▐ ▝▄▜ ▝▄▟▘▐ ▐ ▗▟▄ ▝▙▞  ▝▄ ▝▙█

EOF
)

print_banner() {
	echo -e "${Red}${BANNER}${Reset}"
	echo -e "\n${Cyan}AkumaShield${Reset} — not yet another one-off hardening script"
	echo -e "${Cyan}Author${Reset}: Sandip Duley\n"
}

# Global flags
SHOW_HELP=false
RUN_MODE=false
FIX_MODE=false
DRY_RUN=false
ONLY_MODULES=""

# Argument parsing
for arg in "$@"; do
	case "$arg" in
	-h | --help) SHOW_HELP=true ;;
	--audit) RUN_MODE=true ;;
	--fix) RUN_MODE=true FIX_MODE=true ;;
	--dry-run) DRY_RUN=true ;;
	--only=*) ONLY_MODULES="${arg#*=}" ;;
	*)
		echo "[!] Unknown option: $arg"
		exit 1
		;;
	esac
done

export FIX_MODE DRY_RUN ONLY_MODULES

print_help() {
	cat <<EOF
Usage: sudo ./akumashield.sh [OPTIONS]

Modes:
  --audit            Audit only
  --fix              Audit + fix safe issues

Options:
  --dry-run          Show actions without applying
  --only=MODULES     Run only specific modules
  -h, --help         Show help

Example:
  sudo ./akumashield.sh --audit
  sudo ./akumashield.sh --fix --only=passwd
EOF
}

# Module runner
run_modules() {
	case "$ONLY_MODULES" in
	"")
		run_passwd_module
		run_shadow_module
		run_group_module
		;;
	# passwd)
	# 	run_passwd_module
	# 	;;
	# shadow)
	# 	run_shadow_module
	# 	;;
	*)
		echo "[!] Unknown module: $ONLY_MODULES"
		exit 1
		;;
	esac
}

# MAIN (ONLY EXECUTION POINT)
main() {

	if [[ "$SHOW_HELP" == true ]]; then
		print_help
		exit 0
	fi

	if [[ "$RUN_MODE" != true ]]; then
		echo "[!] No execution mode selected"
		exit 1
	fi

	print_banner

	# log_init

	run_modules

	# echo "-------------------------------------------------------------------------"
	# log_info "AkumaShield run completed successfully"
}

main "$@"
