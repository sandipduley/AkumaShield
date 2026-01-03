#!/usr/bin/env bash

# Bash (ANSI) color codes
# RED="\e[31m"
GREEN="\e[32m"
# YELLOW="\e[33m"
# BLUE="\e[34m"
RESET="\e[0m"
#
echo -e "\n${GREEN}[X]Checking malicious users....${RESET}"

echo -e "${GREEN}[X]Printing non system users from /etc/passwd file Username, UID, Shell\n${RESET}"

awk -F: '$3 > 999 {
    printf "[NON SYSTEM USERs] %-15s UID=%-5s SHELL=%s\n", $1, $3, $7
}' /etc/passwd
