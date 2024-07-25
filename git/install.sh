#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

LOCAL_GIT_CONFIG="${HOME}/.gitconfig.local"

copy_gitconfig_local() {
    if [ ! -f "${LOCAL_GIT_CONFIG}" ]; then
        cp "${PWD}/git/.gitconfig.local" "${LOCAL_GIT_CONFIG}"

        echo "Enter your email address:"
        read -r email
        sed -i '' "s|GIT_EMAIL|${email}|" "${LOCAL_GIT_CONFIG}"
        sed -i '' "s|GIT_SIGNKEY|${SSH_KEY_PATH}|" "${LOCAL_GIT_CONFIG}"
    fi
}

create_symlinks() {
    ln -sf "${PWD}/git/.gitconfig" "${HOME}/.gitconfig"
    ln -sf "${PWD}/git/.gitignore" "${HOME}/.gitignore"
}

main() {
    echo "Setting up git..."
    copy_gitconfig_local
    create_symlinks
}

main
