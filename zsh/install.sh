#!/usr/bin/env zsh
set -e

touch "${HOME}/.secrets"
ln -sf "${PWD}/zsh/.zshrc" "${HOME}/.zshrc"
