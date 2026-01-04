#!/usr/bin/env bash

# --- Bash (ANSI) color codes ---
# RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_non_system_users() {
	local passwd_file="/etc/passwd"

	echo -e "\n${GREEN}[X] Checking malicious users on ${passwd_file} file....${RESET}"

	echo -e "${GREEN}[X] Printing non system users from ${passwd_file} file Username, UID, Shell....\n${RESET}"

	awk -F: '$3 > 1000 {
		printf "[NON SYSTEM USERs] %-15s UID=%-5s SHELL=%s\n", $1, $3, $7
	}' ${passwd_file}

	echo -e "\n${YELLOW}[!] If any unknown users/backdoor are found, remove them immediately.${RESET}"
}
check_non_system_users

echo "======================================================================"

check_passwd_ownership() {
	local passwd_file="/etc/passwd"

	local passwd_owner
	passwd_owner=$(stat -c "%U" "${passwd_file}")

	loacl passwd_group
	passwd_group=$(stat -c "%G" "${passwd_file}")

	echo -e "\n${GREEN}[X] Checking ${passwd_file} file ownership....${RESET}"

	if [[ ${passwd_owner} && ${passwd_group} == root ]]; then
		echo -e "\n${passwd_file} file is secure default (${passwd_owner}:${passwd_group})"
	else
		echo -e "${YELLOW}[WARN] Someone messed with the ${passwd_file} file ownership (${passwd_owner})${RESET}"

		chown root:root ${passwd_file}
		passwd_owner=$(stat -c "%U" "${passwd_file}")

		echo "[FIXED] ${passwd_file} file ownership set to default (${passwd_owner})"
	fi
}

check_passwd_ownership

echo "======================================================================"
