#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

DIR="${CONFIG_DIR}/tmux/"
PWD_PATH="${PWD}/tmux/"

main () {
    echo "Setting up tmux...\n"

    if [ ! -d "${DIR}" ]; then
        mkdir -p ${DIR}
    fi
    if [ -d "${HOME}/.tmux/plugins/tpm" ]; then
        rm -rf "${HOME}/.tmux/plugins/tpm"
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    echo "\nLinking files...\n"

    local file=".tmux.conf"
    ln -sf "${PWD_PATH}${file}" "${DIR}${file}"
    }

main
