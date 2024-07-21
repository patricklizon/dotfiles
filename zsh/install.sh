#!/usr/bin/env zsh
set -e

main() {
    [ -f "${HOME}/.secrets" ] || touch "${HOME}/.secrets"
    ln -sf "${PWD}/zsh/.zshrc" "${HOME}/.zshrc"
}

main
