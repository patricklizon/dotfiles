#!/usr/bin/env zsh
set -e

OMZ_DIR="${HOME}/.oh-my-zsh"
CUSTOM_DIR="${OMZ_DIR}/custom"

# Install Oh My Zsh if not already installed
if [ ! -d "${OMZ_DIR}" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh is already installed"
fi

# Symlink custom files
for it in aliases exports functions bind; do
    ln -sf "${PWD}/omz/${it}.zsh" "${CUSTOM_DIR}/${it}.zsh"
done
