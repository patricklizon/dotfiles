#!/usr/bin/env zsh
set -e

main() {
    fnm install --lts
    fnm default lts/latest
}

main
