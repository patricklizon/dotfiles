#!/usr/bin/env zsh
set -e

HOME_CONFIG="${HOME}/.gitconfig.local"
PWD_CONFIG="${PWD}/git/.gitconfig.local"

if [ ! -f "${HOME_CONFIG}" ] ; then
    cp "${PWD_CONFIG}" "${HOME_CONFIG}"

    echo "Enter your email address:"
    read -r email
    sed -i '' "s|GIT_EMAIL|${email}|" "${HOME_CONFIG}"

    echo "Enter the path to your public SSH key:"
    read -r ssh_key_path
    sed -i '' "s|GIT_SIGNKEY|${ssh_key_path}|" "${HOME_CONFIG}"
fi

ln -sf "${PWD}/git/.gitconfig" "${HOME}/.gitconfig"
ln -sf "${PWD}/git/.gitignore" "${HOME}/.gitignore"
