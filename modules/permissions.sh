#!/usr/bin/env bash

# --- Bash (ANSI) color codes ---
# RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_shadow_permission() {
	local file="/etc/shadow"
	local permission
	permission=$(stat -c "%a" "${file}")

	echo -e "\n${GREEN}[X] Checking ${file} permissions....${RESET}"

	if [[ ${permission} -eq 600 ]]; then
		echo -e "\n${file} permissions is secure (${permission})"
	else
		echo -e "${YELLOW}[WARN] ${file} permissions appear to be tampered with (${permission})${RESET}"

		chmod 600 /etc/shadow
		permission=$(stat -c "%a" "${file}")

		echo -e "[FIXED] ${file} permissions set to (${permission})"
	fi
}
check_shadow_permission

echo "======================================================================"

check_passwd_permission() {
	local file="/etc/passwd"
	local permission
	permission=$(stat -c "%a" "${file}")

	echo -e "\n${GREEN}[X] Checking ${file} permissions....${RESET}"

	if [[ ${permission} -eq 644 ]]; then
		echo -e "\n${file} permission is secure (${permission})"
	else
		echo -e "${YELLOW}[WARN] ${file} permissions appear to be tampered with (${permission})${RESET}"

		chmod 644 /etc/passwd
		permission=$(stat -c "%a" "${file}")

		echo "[FIXED] ${file} permission set to (${permission})"
	fi
}
check_passwd_permission

echo "======================================================================"
