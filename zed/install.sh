#!/usr/bin/env zsh
set -e

CONFIG_PATH=${HOME}/.config/zed/
PWD_PATH=${PWD}/zed

main() {
    mkdir --parents ${CONFIG_PATH}
    ln -sf "${PWD_PATH}/settings.json" "${CONFIG_PATH}/settings.json"
    ln -sf "${PWD_PATH}/keybindings.json" "${CONFIG_PATH}/keymap.json"
}

main
