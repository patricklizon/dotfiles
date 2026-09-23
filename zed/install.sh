#!/usr/bin/env zsh
set -e

source "${0:A:h:h}/constants.sh"

DIR="${CONFIG_DIR}/zed/"
PWD_PATH="${0:A:h}/"

main() {
	echo "Setting up zed..."
	local backup_dir=""

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

		if [[ -L "$destination" && "$(readlink "$destination")" == "$target" ]]; then
			continue
		fi

		if [[ -e "$destination" || -L "$destination" ]]; then
			if [[ -z "$backup_dir" ]]; then
				backup_dir=$(mktemp -d "${DIR}backup.XXXXXX")
			fi
			mv "$destination" "${backup_dir}/${link}"
			printf 'Backed up %s to %s\n' "$destination" "$backup_dir"
		fi

		ln -s "$target" "$destination"
	done
}

main
