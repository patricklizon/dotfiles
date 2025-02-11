#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

DIR="${CONFIG_DIR}/zed/"
PWD_PATH="${PWD}/zed/"

main() {
	echo "Setting up zed..."

	if [ ! -d "${DIR}" ]; then
		mkdir -p "${DIR}"
	fi

	links=(
		settings.json
		keymap.json
		tasks.json
		snippets
	)

	for link in "${links[@]}"; do
		target="${PWD_PATH}${link}"
		destination="${DIR}${link}"

		# If linking a directory, remove existing and create a new link
		if [ -d "$target" ]; then
			rm -rf "$destination"
		fi

		ln -snf "$target" "$destination"
	done
}

main
