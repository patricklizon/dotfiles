#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

DIR="${CONFIG_DIR}/zed/"
PWD_PATH="${PWD}/zed/"

main() {
    echo "Setting up zed..."

    if [ ! -d "${DIR}" ]; then
        mkdir -p ${DIR}
    fi

    files=(
        settings.json
        keymap.json
    )

    for file in "${files[@]}"; do
        ln -sf "${PWD_PATH}${file}" "${DIR}${file}"
    done
}

main
