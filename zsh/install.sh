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

add_initializers() {
    local initializers=(
        'eval "$(fnm env --use-on-cd)"'
        'eval "$(fzf --zsh)"'
    )

    for initializer in "${initializers[@]}"; do
        if ! grep -qF "${initializer}" "${HOME}/.initializers"; then
            printf '\n%s\n' "${initializer}" >> "${HOME}/.initializers"
            printf "Added initializer to ~/.initializers: %s\n" "${initializer}"
        fi
    done
}

main() {
    echo "Setting up zsh..."

    check_and_create_file "${HOME}/.secrets"
    check_and_create_file "${HOME}/.initializers"
    add_initializers

    ln -sf "${PWD}/zsh/.zshrc" "${HOME}/.zshrc"
}

main
