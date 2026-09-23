#!/usr/bin/env zsh
set -e

source "${0:A:h:h}/constants.sh"

DIR="${HOME}/"
PWD_PATH="${0:A:h}/"


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
