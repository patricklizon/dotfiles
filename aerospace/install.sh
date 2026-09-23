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
	local source="${PWD_PATH}${file}"
	local destination="${DIR}.aerospace.toml"

	if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
		return
	fi

	if [[ -e "$destination" || -L "$destination" ]]; then
		local backup_dir
		backup_dir=$(mktemp -d "${HOME}/.dotfiles-backup.XXXXXX")
		mv "$destination" "${backup_dir}/.aerospace.toml"
		printf 'Backed up %s to %s\n' "$destination" "$backup_dir"
	fi

	ln -s "$source" "$destination"
}

main
