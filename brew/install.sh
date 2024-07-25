#!/usr/bin/env zsh
set -e

# Define packages, fonts, and apps
packages=(
    # gh # https://cli.github.com
    ack # https://github.com/samaaron/ack
    fnm # https://github.com/Schniz/fnm
    fzf # https://github.com/junegunn/fzf
    git
    glow # https://github.com/charmbracelet/glow
    gnupg # https://github.com/gpg/gnupg
    gron # https://github.com/tomnomnom/gron
    jq # https://github.com/jqlang/jq
    shellcheck # https://github.com/koalaman/shellcheck
    tealdeer # https://github.com/dbrgn/tealdeer
    tmux # https://github.com/tmux/tmux/wiki
    qemu # https://gitlab.com/qemu-project/qemu
)

fonts=(
    font-fira-code
    font-hack-nerd-font
    font-jetbrains-mono
)

apps=(
    firefox
    google-chrome
    iterm2 # https://github.com/gnachman/iTerm2
    keepassxc # https://github.com/keepassxreboot/keepassxc
    proxyman # https://github.com/ProxymanApp/Proxyman
    rectangle # https://github.com/rxhanson/Rectangle
    stats # https://github.com/exelban/stats
    transmission # https://github.com/transmission/transmission
    zed # https://github.com/zed-industries/zed
)

casks=(${fonts[@]} ${apps[@]})

is_already_installed_with_brew() {
    local pkg=$1
    if brew list --formula | grep -q "^${pkg}\$" || brew list --cask | grep -q "^${pkg}\$"; then
        return 0
    else
        return 1
    fi

}

install_with_brew() {
    bold() {
        echo -e "\033[1m${text}\033[0m"
    }

    local pkg=$1
    local is_cask=$2

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        return 1
    fi

    if is_already_installed_with_brew "$pkg" "$is_cask"; then
        echo "$pkg is already installed."
    else
        echo "$pkg is not found. Installing now..."
        if [ "$is_cask" = "--cask" ]; then
            if brew install --cask "$pkg"; then
                echo "The cask ${pkg} has been successfully installed."
            else
                echo "Failed to install the cask $pkg."
            fi
        else
            if brew install "$pkg"; then
                echo "The formula ${pkg} has been successfully installed."
            else
                echo "Failed to install the formula $pkg."
            fi
        fi
    fi
}

install_packages() {
    for pkg in "${packages[@]}"; do
        install_with_brew "${pkg}"
    done
}

install_casks() {
    for cask in "${casks[@]}"; do
        install_with_brew "${cask}" "--cask"
    done
}

cleanup() {
    echo "Cleaning up\n"
    brew autoremove --verbose
    brew cleanup --prune=all
}

# Function to add initializers to .zshrc
add_initializers_to_zshrc() {
    local initializers=(
        'eval "$(fnm env --use-on-cd)"'
        'eval "$(fzf --zsh)"'
    )

    for initializer in "${initializers[@]}"; do
        if ! grep -qF "${initializer}" "${HOME}/.initializers"; then
            printf '\n%s\n' "${initializer}" >> "${HOME}/.initializers"
            printf "Added initializer to ~/.initializers: %s\n" "${initializer}"
        fi
    done
}

main() {
    if test ! $(which brew); then
        printf "\nInstalling the brew package manager\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    install_packages
    install_casks
    cleanup
    add_initializers_to_zshrc

    printf "\nRestart your terminal or source your ~/.zshrc file.\n"
}

main
