#!/usr/bin/env zsh
set -e

[ -f "${HOME}/.secrets" ] || touch "${HOME}/.secrets"

ln -sf "${PWD}/zsh/.zshrc" "${HOME}/.zshrc"
