#!/usr/bin/env bash

run_group_module() {
	log_info "Running Group Security Module"

	check_gid_zero_groups
	check_group_file_security
	check_wheel_group_members
	check_privileged_groups
}

# Check for GID 0 Groups

check_gid_zero_groups() {
	local group_file="/etc/group"
	local gid0_count
	local non_root_gid0

	log_info "Checking for GID 0 groups..."

	gid0_count=$(awk -F: '$3 == 0 {c++} END {print c+0}' "$group_file")

	if [[ "$gid0_count" -eq 0 ]]; then
		log_critical "No GID 0 group found. System misconfigured."
		return
	fi

	if [[ "$gid0_count" -gt 1 ]]; then
		log_critical "Multiple GID 0 groups detected ($gid0_count)"
		awk -F: '$3 == 0 {print " - " $1}' "$group_file"
	fi

	non_root_gid0=$(awk -F: '$3 == 0 && $1 != "root" {found=1} END {print found+0}' "$group_file")

	if [[ "$non_root_gid0" -eq 1 ]]; then
		awk -F: '
            $3 == 0 && $1 != "root" {
                print "[CRITICAL] Non-root group with GID 0: " $1
            }' "$group_file"
	else
		log_success "Only root group has GID 0."
	fi
}

# Check /etc/group file permissions & ownership

check_group_file_security() {
	local group_file="/etc/group"
	local permission
	local owner

	log_info "Checking $group_file file security..."

	permission=$(stat -c "%a" "$group_file")
	owner=$(stat -c "%U:%G" "$group_file")

	# Permission check
	if [[ "$permission" == "644" ]]; then
		log_success "$group_file permissions are secure (644)"
	else
		log_warn "$group_file permissions are $permission (expected 644)"

		if [[ "$FIX_MODE" == true ]]; then
			chmod 644 "$group_file"
			permission=$(stat -c "%a" "$group_file")
			log_success "Permissions fixed → $permission"
		fi
	fi

	# Ownership check
	if [[ "$owner" == "root:root" ]]; then
		log_success "$group_file ownership is secure (root:root)"
	else
		log_warn "$group_file ownership is $owner (expected root:root)"

		if [[ "$FIX_MODE" == true ]]; then
			chown root:root "$group_file"
			owner=$(stat -c "%U:%G" "$group_file")
			log_success "Ownership fixed → $owner"
		fi
	fi
}

# Check wheel group members

check_wheel_group_members() {
	local group_file="/etc/group"
	local members

	log_info "Checking wheel group members..."

	members=$(awk -F: '$1=="wheel"{print $4}' "$group_file")

	if [[ -z "$members" ]]; then
		log_info "wheel group not found or no members."
		return
	fi

	if [[ "$members" == "" ]]; then
		log_success "wheel group has no members."
	else
		log_warn "wheel group members detected: $members"
		log_info "Review these accounts carefully."
	fi
}

# Check Privileged Groups

check_privileged_groups() {
	local group_file="/etc/group"
	local privileged_groups=("wheel" "sudo" "adm" "shadow" "disk" "docker" "lxd" "libvirt" "kvm")
	local found_privileged=false

	log_info "Checking privileged group memberships..."

	for grp in "${privileged_groups[@]}"; do
		local members
		members=$(awk -F: -v grp="$grp" '$1 == grp {print $4}' "$group_file")

		if [[ -n "$members" ]]; then
			found_privileged=true
			log_warn "Privileged group detected: $grp"

			IFS=',' read -ra users <<<"$members"

			for user in "${users[@]}"; do
				log_warn " - User: $user"

				if [[ "$FIX_MODE" == true ]]; then
					if gpasswd -d "$user" "$grp" >/dev/null 2>&1; then
						log_success "Removed $user from $grp"
					else
						log_critical "Failed to remove $user from $grp"
					fi
				fi
			done
		fi
	done

	if [[ "$found_privileged" == false ]]; then
		log_success "No privileged group members detected."
	else
		log_warn "Review privileged group memberships immediately."
	fi
}
