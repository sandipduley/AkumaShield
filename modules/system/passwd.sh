#!/usr/bin/env bash

# entry
run_passwd_module() {
	log_info "Running Passwd Security Module"

	check_non_system_users
	check_uid_zero_accounts
	check_passwd_permission
	check_passwd_ownership
}

# detect regular login users
check_non_system_users() {
	local file="/etc/passwd"

	log_info "Checking non-system users"

	local result
	result=$(awk -F: '$3 >= 1000 && $7 !~ /(nologin|false)$/ {
		printf "User=%s UID=%s Shell=%s\n", $1, $3, $7
	}' "$file")

	if [[ -n "$result" ]]; then
		log_warn "Non-system users detected"
		while IFS= read -r line; do
			log_info "$line"
		done <<<"$result"
	else
		log_secure "No suspicious non-system users found"
	fi
}

# check uid 0 accounts
check_uid_zero_accounts() {
	local file="/etc/passwd"

	log_info "Checking UID 0 accounts"

	local uid0_accounts
	uid0_accounts=$(awk -F: '$3 == 0 {print $1}' "$file")

	local count
	count=$(wc -l <<<"$uid0_accounts")

	if ((count == 0)); then
		log_critical "No UID 0 account found"
		return
	fi

	if ((count > 1)); then
		log_critical "Multiple UID 0 accounts detected ($count)"
		while IFS= read -r user; do
			[[ "$user" != "root" ]] && log_critical "Non-root UID 0 account: $user"
		done <<<"$uid0_accounts"
	else
		log_secure "Only root has UID 0"
	fi
}

# verify permissions
check_passwd_permission() {
	local file="/etc/passwd"
	local perm
	perm=$(stat -c "%a" "$file")

	log_info "Checking /etc/passwd permissions"

	if [[ "$perm" == "644" ]]; then
		log_secure "Permissions are secure (644)"
	else
		log_warn "Permissions are $perm (expected 644)"

		if [[ "$FIX_MODE" == true ]]; then
			chmod 644 "$file"
			log_fixed "Permissions corrected to 644"
		fi
	fi
}

# verify ownership
check_passwd_ownership() {
	local file="/etc/passwd"
	local owner group
	owner=$(stat -c "%U" "$file")
	group=$(stat -c "%G" "$file")

	log_info "Checking /etc/passwd ownership"

	if [[ "$owner" == "root" && "$group" == "root" ]]; then
		log_secure "Ownership is root:root"
	else
		log_warn "Ownership is $owner:$group (expected root:root)"

		if [[ "$FIX_MODE" == true ]]; then
			chown root:root "$file"
			log_fixed "Ownership corrected to root:root"
		fi
	fi
}
