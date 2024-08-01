#!/usr/bin/env zsh
set -e

COMMAND="${1}"
PACKAGE="${2}"

function usage() {
	echo "Usage: $0 install <package>"
	exit 1
}

function run_script() {
	local action="$1"
	echo "\nSetting up: ${PACKAGE}\n"
	"${PACKAGE}/${action}.sh"
	echo "\ndone\n"
	}

[[ -z "${COMMAND}" || -z "${PACKAGE}" ]] && usage

if [[ "${COMMAND}" == "install" ]]; then
	run_script "install"
else
	echo "Invalid command: ${COMMAND}"
	exit 3
fi
