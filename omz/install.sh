#!/usr/bin/env zsh
set -e
SCRIPT_DIR="${0:A:h}"

OMZ_DIR="${HOME}/.oh-my-zsh"
CUSTOM_DIR="${OMZ_DIR}/custom"

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

install_oh_my_zsh() {
    if [ ! -d "${OMZ_DIR}" ]; then
        echo "Installing Oh My Zsh...\n"
        CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh is already installed.\n"
    fi
}

# Function to symlink custom files
symlink_custom_files() {
    echo "Symlinking custom files...\n"
    local backup_dir=""

    for it in aliases exports functions bind; do
        target="${CUSTOM_DIR}/${it}.zsh"
        source="${SCRIPT_DIR}/${it}.zsh"

        if [[ -L "${target}" && "$(readlink "${target}")" == "${source}" ]]; then
            continue
        fi

        if [[ -e "${target}" || -L "${target}" ]]; then
            if [[ -z "${backup_dir}" ]]; then
                backup_dir=$(mktemp -d "${CUSTOM_DIR}/dotfiles-backup.XXXXXX")
            fi
            mv "${target}" "${backup_dir}/${it}.zsh"
            printf 'Backed up %s to %s\n' "${target}" "${backup_dir}"
        fi

        ln -s "${source}" "${target}"
        echo "Symlinked ${source} to ${target}"
    done
}

main() {
    echo "Setting up oh-my-zsh...\n"
    install_oh_my_zsh
    symlink_custom_files
}

main
