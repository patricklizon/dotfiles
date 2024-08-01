#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

DIR="${CONFIG_DIR}/tmux/"
TPM_DIR="${HOME}/.tmux/plugin/tpm"
PWD_PATH="${PWD}/tmux/"

install_tpm() {
	if test ! -d ~/.tmux/plugins/tpm "${TPM_DIR}"; then
		git clone "https://github.com/tmux-plugins/tpm ${TPM_DIR}"
	fi

	${TPM_DIR}/bin/install_plugins
}

main() {
	echo "Setting up tmux...\n"

	if [ ! -d "${DIR}" ]; then
		mkdir -p ${DIR}
	fi

	echo "\nLinking files...\n"

	local file="tmux.conf"
	ln -sf "${PWD_PATH}${file}" "${DIR}${file}"

	echo "\nInstalling tpm...\n"

	install_tpm
}

main
