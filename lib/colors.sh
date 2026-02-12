#!/usr/bin/env bash

# Enable colors only if output is a terminal
if [[ -t 1 ]]; then
	Black='\033[0;30m'
	Red='\033[0;31m'
	Green='\033[0;32m'
	Yellow='\033[0;33m'
	Blue='\033[0;34m'
	Purple='\033[0;35m'
	Cyan='\033[0;36m'
	White='\033[0;37m'

	BBlack='\033[1;30m'
	BRed='\033[1;31m'
	BGreen='\033[1;32m'
	BYellow='\033[1;33m'
	BBlue='\033[1;34m'
	BPurple='\033[1;35m'
	BCyan='\033[1;36m'
	BWhite='\033[1;37m'

	Reset='\033[0m'
else
	# Disable colors when not writing to terminal
	Black=''
	Red=''
	Green=''
	Yellow=''
	Blue=''
	Purple=''
	Cyan=''
	White=''

	BBlack=''
	BRed=''
	BGreen=''
	BYellow=''
	BBlue=''
	BPurple=''
	BCyan=''
	BWhite=''

	Reset=''
fi
