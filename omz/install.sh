#!/usr/bin/env zsh
set -e

OMZ_DIR="${HOME}/.oh-my-zsh"
CUSTOM_DIR="${OMZ_DIR}/custom"

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

install_oh_my_zsh() {
    if [ ! -d "${OMZ_DIR}" ]; then
        echo "Installing Oh My Zsh...\n"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh is already installed.\n"
    fi
}

# Function to symlink custom files
symlink_custom_files() {
    echo "Symlinking custom files...\n"

    for it in aliases exports functions bind; do
        target="${CUSTOM_DIR}/${it}.zsh"
        source="${PWD}/omz/${it}.zsh"

        if [ -e "${target}" ]; then
            echo "Backing up existing file: ${target}"
            mv "${target}" "${target}.backup"
        fi

        ln -sf "${source}" "${target}"

        if [ $? -eq 0 ]; then
            echo "Symlinked ${source} to ${target}"
        else
            echo "Error symlinking ${source} to ${target}"
            exit 1
        fi
    done
}

main() {
    echo "Setting up oh-my-zsh...\n"
    install_oh_my_zsh
    symlink_custom_files
}

main
