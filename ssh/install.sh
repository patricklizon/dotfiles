#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

configure_macos_keychain() {
    echo "Adding ssh key to keychain...\n"

    /usr/bin/ssh-add --apple-use-keychain "${SSH_KEY_PATH}"

    if ! grep -q "# managed-by-dotfiles: macos-keychain" "${SSH_CONFIG_DIR}" 2>/dev/null; then
        printf '\n# managed-by-dotfiles: macos-keychain\nHost *\n  UseKeychain yes\n  AddKeysToAgent yes\n  IdentityFile %s\n' "${SSH_KEY_PATH}" >> "${SSH_CONFIG_DIR}"

        echo "Configured macOS keychain integration in ~/.ssh/config.\n"
    fi
}

main() {
    echo "Setting up SSH key...\n"

    if [ ! -f "${SSH_KEY_PATH}" ]; then
        ssh-keygen -t "${SSH_KEY_TYPE}" -f "${SSH_KEY_PATH}"
    else
        echo "SSH key already exists at ${SSH_KEY_PATH}, skipping generation.\n"
    fi

    eval "$(ssh-agent -s)"
    ssh-add "${SSH_KEY_PATH}"

    configure_macos_keychain
}

main
