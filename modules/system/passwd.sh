#!/usr/bin/env bash
source "${SCRIPT_DIR}/lib/colors.sh"

check_passwd_permission() {
	local passwd_file="/etc/passwd"
	local permission
	permission=$(stat -c "%a" "${passwd_file}")

	echo -e "\n${Green}[X] Checking ${passwd_file} file permissions....${Reset}"

	if [[ ${permission} -eq 644 ]]; then
		echo -e "\n[✓] ${passwd_file} file permission is secure default (${permission})"
	else
		echo -e "${Yellow}[WARN] ${passwd_file} file permissions appear to be tampered with (${permission})${Reset}"

		chmod 644 /etc/passwd
		permission=$(stat -c "%a" "${passwd_file}")

		echo "[FIXED] ${passwd_file} file permission set to default (${permission})"
	fi
}
check_passwd_permission

check_passwd_ownership() {
	local passwd_file="/etc/passwd"

	local passwd_owner
	passwd_owner=$(stat -c "%U" "${passwd_file}")

	local passwd_group
	passwd_group=$(stat -c "%G" "${passwd_file}")

	echo -e "\n${Green}[X] Checking ${passwd_file} file ownership....${Reset}"

	if [[ ${passwd_owner} && ${passwd_group} == root ]]; then
		echo -e "\n[✓] ${passwd_file} file is secure default (${passwd_owner}:${passwd_group})"
	else
		echo -e "${Yellow}[WARN] Someone messed with the ${passwd_file} file ownership (${passwd_owner})${Reset}"

		chown root:root ${passwd_file}
		passwd_owner=$(stat -c "%U" "${passwd_file}")

		echo "[FIXED] ${passwd_file} file ownership set to default (${passwd_owner})"
	fi
}

check_passwd_ownership
