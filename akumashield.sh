#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/colors.sh"

echo -e "                                            
${Red} ▗▖ ▐                ▄▄ ▐    ▝      ▝▜    ▐ ${Reset} 
${Red} ▐▌ ▐ ▗ ▗ ▗ ▗▄▄  ▄▖ ▐▘ ▘▐▗▖ ▗▄   ▄▖  ▐   ▄▟ ${Reset} 
${Red} ▌▐ ▐▗▘ ▐ ▐ ▐▐▐ ▝ ▐ ▝▙▄ ▐▘▐  ▐  ▐▘▐  ▐  ▐▘▜ ${Reset} 
${Red} ▙▟ ▐▜  ▐ ▐ ▐▐▐ ▗▀▜   ▝▌▐ ▐  ▐  ▐▀▀  ▐  ▐ ▐ ${Reset} 
${Red}▐  ▌▐ ▚ ▝▄▜ ▐▐▐ ▝▄▜ ▝▄▟▘▐ ▐ ▗▟▄ ▝▙▞  ▝▄ ▝▙█ ${Reset} 
"
echo -e "${Cyan}AkumaShield${Reset} — not yet another one-off hardening script"
echo "Author: Sandip Duley"

check_root_privilege() {
	if [ "$EUID" -ne 0 ]; then
		echo -e "\n${Red}[X] AkumaShield must be run with sudo. Before running with elevated privileges, review the source code.${Reset}"
		exit 1
	else
		echo -e "\n${Green}[✓] Running as root...${Reset}"
	fi
}
check_root_privilege

chmod +x modules/*
