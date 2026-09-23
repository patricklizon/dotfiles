#!/usr/bin/env zsh
set -e

source "${0:A:h:h}/constants.sh"

DIR="${CONFIG_DIR}/tmux/"
TPM_DIR="${HOME}/.tmux/plugins/tpm"
PWD_PATH="${0:A:h}/"

install_tpm() {
	if [ ! -d "${TPM_DIR}" ]; then
		git clone "https://github.com/tmux-plugins/tpm" "${TPM_DIR}"
	fi

	"${TPM_DIR}/bin/install_plugins"
}

main() {
	echo "Setting up tmux...\n"

	if [ ! -d "${DIR}" ]; then
		mkdir -p "${DIR}"
	fi

	echo "\nLinking files...\n"

	local file="tmux.conf"
	local source="${PWD_PATH}${file}"
	local destination="${DIR}${file}"

	if [[ ! -L "$destination" || "$(readlink "$destination")" != "$source" ]]; then
		if [[ -e "$destination" || -L "$destination" ]]; then
			local backup_dir
			backup_dir=$(mktemp -d "${DIR}backup.XXXXXX")
			mv "$destination" "${backup_dir}/${file}"
			printf 'Backed up %s to %s\n' "$destination" "$backup_dir"
		fi
		ln -s "$source" "$destination"
	fi

	echo "\nInstalling tpm...\n"

	install_tpm
}

main
