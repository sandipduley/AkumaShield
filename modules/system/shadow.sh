#!/usr/bin/env bash

# entry
run_shadow_module() {
	log_info "Running Shadow Security Module"

	check_shadow_permission
	check_shadow_ownership
}

# verify permissions
check_shadow_permission() {
	local file="/etc/shadow"
	local perm

	perm=$(stat -c "%a" "$file" 2>/dev/null) || {
		log_critical "Unable to read $file"
		return
	}

	log_info "Checking /etc/shadow permissions"

	if [[ "$perm" == "600" ]]; then
		log_secure "Permissions are secure (600)"
	else
		log_critical "Permissions are $perm (expected 600)"

		if [[ "$FIX_MODE" == true ]]; then
			chmod 600 "$file" && log_fixed "Permissions corrected to 600"
		fi
	fi
}

# verify ownership
check_shadow_ownership() {
	local file="/etc/shadow"
	local owner group

	owner=$(stat -c "%U" "$file" 2>/dev/null) || {
		log_critical "Unable to read $file owner"
		return
	}

	group=$(stat -c "%G" "$file")

	log_info "Checking /etc/shadow ownership"

	if [[ "$owner" == "root" && "$group" == "root" ]]; then
		log_secure "Ownership is root:root"
	else
		log_critical "Ownership is $owner:$group (expected root:root)"

		if [[ "$FIX_MODE" == true ]]; then
			chown root:root "$file" && log_fixed "Ownership corrected to root:root"
		fi
	fi
}
