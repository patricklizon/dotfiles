#!/usr/bin/env zsh
set -e

check_and_create_file() {
    local target=$1
    if [ -e "${target}" ]; then
        echo "Backing up existing file: ${target}"
        mv "${target}" "${target}.backup"
    fi

    touch "${target}"
}

add_initializers() {
    local initializers=(
        'eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"'
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
