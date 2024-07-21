#!/usr/bin/env zsh
set -e

source "${PWD}/constants.sh"

configure_macos_keychain() {
    /usr/bin/ssh-add --apple-use-keychain "$SSH_KEY_PATH"

    if ! grep -q "UseKeychain yes" "${SSH_CONFIG}" 2>/dev/null; then
        echo -e "Host *\n  UseKeychain yes\n  AddKeysToAgent yes\n  IdentityFile ${SSH_KEY_PATH}" >> "${SSH_CONFIG}"

        echo "Configured macOS keychain integration in ~/.ssh/config."
    fi
}


main() {
    ssh-keygen -t "${SSH_KEY_TYPE}" -f "${SSH_KEY_PATH}"
    eval "$(ssh-agent -s)"
    ssh-add "${SSH_KEY_PATH}"

    configure_macos_keychain
}

main
