#!/usr/bin/env zsh
set -e

main() {
    echo "Setting up node LTS...\n"

    fnm install --lts
    fnm default lts/latest
}

main
