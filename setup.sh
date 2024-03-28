#!/usr/bin/env bash

set -euo pipefail

TARGET=$(realpath ./keyd)

function run_with_echo() {
	echo "> Running: $@"
	"$@"
}

# if /etc/keyd directory is already a symlink to our target, skip
if [ -L /etc/keyd ]; then
	if [ "$(readlink /etc/keyd)" = "$TARGET" ]; then
		echo "/etc/keyd is already a symlink to $TARGET"
		exit 0
	fi
fi

# Check if /etc/keyd directory exists, then ask to remove it first
if [ -d /etc/keyd ]; then
	read -p "Directory /etc/keyd already exists. Remove it? (y/N) " -n1 yn
	echo ""
	case $yn in
	[Yy]) run_with_echo sudo rm -rf /etc/keyd ;;
	*)
		echo "You haven't answered yes, skipping keyd setup."
		exit 0
		;;
	esac
fi

run_with_echo sudo ln -sf $TARGET /etc/keyd
