#!/usr/bin/env zsh
set -e

check_and_create_file() {
    local file_path=$1
    if [ -f "$file_path" ]; then
        echo "The file $file_path already exists."
    else
        echo "The file $file_path does not exist. Creating it now."
        touch "$file_path"
    fi
}


main() {
    echo "Setting up zsh..."

    check_and_create_file "${HOME}/.secrets"
    check_and_create_file "${HOME}/.initializers"

    ln -sf "${PWD}/zsh/.zshrc" "${HOME}/.zshrc"
}

main
