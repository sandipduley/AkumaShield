#!/usr/bin/env bash

# --- Bash (ANSI) color codes ---
# RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_shadow_permission() {
	local shadow_file="/etc/shadow"
	local permission
	permission=$(stat -c "%a" "${shadow_file}")

	echo -e "\n${GREEN}[X] Checking ${shadow_file} file permissions....${RESET}"

	if [[ ${permission} -eq 600 ]]; then
		echo -e "\n${shadow_file} file permissions is secure default (${permission})"
	else
		echo -e "${YELLOW}[WARN] ${shadow_file} file permissions appear to be tampered with (${permission})${RESET}"

		chmod 600 /etc/shadow
		permission=$(stat -c "%a" "${shadow_file}")

		echo -e "[FIXED] ${shadow_file} file permissions set to default (${permission})"
	fi
}
check_shadow_permission

echo "======================================================================"

check_passwd_permission() {
	local passwd_file="/etc/passwd"
	local permission
	permission=$(stat -c "%a" "${passwd_file}")

	echo -e "\n${GREEN}[X] Checking ${passwd_file} file permissions....${RESET}"

	if [[ ${permission} -eq 644 ]]; then
		echo -e "\n${passwd_file} file permission is secure default (${permission})"
	else
		echo -e "${YELLOW}[WARN] ${passwd_file} file permissions appear to be tampered with (${permission})${RESET}"

		chmod 644 /etc/passwd
		permission=$(stat -c "%a" "${passwd_file}")

		echo "[FIXED] ${passwd_file} file permission set to default (${permission})"
	fi
}
check_passwd_permission

echo "======================================================================"
