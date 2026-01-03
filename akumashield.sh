#!/usr/bin/env bash

# --- Bash (ANSI) color codes ---
RED="\e[31m"
GREEN="\e[32m"
# YELLOW="\e[33m"
# BLUE="\e[34m"
RESET="\e[0m"

echo -e "                                            
${RED} ▗▖ ▐                ▄▄ ▐    ▝      ▝▜    ▐ ${RESET} 
${RED} ▐▌ ▐ ▗ ▗ ▗ ▗▄▄  ▄▖ ▐▘ ▘▐▗▖ ▗▄   ▄▖  ▐   ▄▟ ${RESET} 
${RED} ▌▐ ▐▗▘ ▐ ▐ ▐▐▐ ▝ ▐ ▝▙▄ ▐▘▐  ▐  ▐▘▐  ▐  ▐▘▜ ${RESET} 
${RED} ▙▟ ▐▜  ▐ ▐ ▐▐▐ ▗▀▜   ▝▌▐ ▐  ▐  ▐▀▀  ▐  ▐ ▐ ${RESET} 
${RED}▐  ▌▐ ▚ ▝▄▜ ▐▐▐ ▝▄▜ ▝▄▟▘▐ ▐ ▗▟▄ ▝▙▞  ▝▄ ▝▙█ ${RESET} 
"
echo "AkumaShield — not yet another one-off hardening script"
echo "Author: Sandip Duley"

check_root_privilege() {
	if [ "$EUID" -ne 0 ]; then
		echo -e "\n${RED}[X] AkumaShield must be run with sudo...${RESET}"
		exit 1
	else
		echo -e "\n${GREEN}[✓]Running as root...${RESET}"
	fi
}
check_root_privilege

chmod +x modules/users.sh

# --- Saves the path and run the module ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/modules/users.sh"
