#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

DIR="${HOME}/"
PWD_PATH="${PWD}/aerospace/"


main() {
	echo "Setting up aerospace...\n"

	if [ ! -d "${DIR}" ]; then
		mkdir -p ${DIR}
	fi

	echo "\nLinking files...\n"

	local file="default-config.toml"
	ln -sf "${PWD_PATH}${file}" "${DIR}.aerospace.toml"
}

main
