#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

DIR="${CONFIG_DIR}/git/"
PWD_PATH="${PWD}/git/"
LOCAL_GIT_CONFIG="${HOME}/.gitconfig.local"

copy_gitconfig_local() {
    if [ ! -f "${LOCAL_GIT_CONFIG}" ]; then
        cp "${PWD_PATH}/.gitconfig.local" "${LOCAL_GIT_CONFIG}"

        echo "Enter your email address:"
        read -r email
        sed -i '' "s|GIT_EMAIL|${email}|" "${LOCAL_GIT_CONFIG}"
        sed -i '' "s|GIT_SIGNKEY|${SSH_KEY_PATH}|" "${LOCAL_GIT_CONFIG}"
    fi
}

create_symlinks() {
    files=(
        .gitconfig.json
        .gitignore.json
    )

    for file in "${files[@]}"; do
        ln -sf "${PWD_PATH}${file}" "${DIR}${file}"
    done
}

main() {
    echo "Setting up git..."
    copy_gitconfig_local
    create_symlinks
}

main
