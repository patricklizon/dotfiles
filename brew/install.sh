#!/usr/bin/env zsh
set -e

# Define packages, fonts, and apps
packages=(
    ack
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
)

fonts=(
    font-fira-code
    font-hack-nerd-font
    font-jetbrains-mono
)

apps=(
    iterm2 # https://github.com/gnachman/iTerm2
    proxyman # https://github.com/ProxymanApp/Proxyman
    rectangle # https://github.com/rxhanson/Rectangle
    transmission # https://github.com/transmission/transmission
    zed # https://github.com/zed-industries/zed
)

# Function to install packages
install_packages() {
    for pkg in "${packages[@]}"; do
        printf "Installing %s\n" "${pkg}"
        if ! brew install "${pkg}"; then
            printf "Failed to install %s\n" "${pkg}" >&2
        fi
    done
}

# Function to install fonts and apps
install_casks() {
    local casks=("${fonts[@]}" "${apps[@]}")
    for cask in "${casks[@]}"; do
        printf "Installing %s\n" "${cask}"
        if ! brew install --cask "${cask}"; then
            printf "Failed to install %s\n" "${cask}" >&2
        fi
    done
}

# Function to clean up Homebrew
cleanup_brew() {
    brew autoremove --verbose
    brew cleanup --prune=all
}

# Function to add initializers to .zshrc
add_initializers_to_zshrc() {
    local initializers=(
        'eval "$(fnm env --use-on-cd)"'
        '$(fzf --zsh)'
    )

    for initializer in "${initializers[@]}"; do
        if ! grep -qF "${initializer}" "${HOME}/.zshrc"; then
            printf '\n%s\n' "${initializer}" >> "${HOME}/.zshrc""
        fi
    done
}

# Main script execution
install_packages
install_casks
cleanup_brew
add_initializers_to_zshrc

printf "Setup complete. Restart your terminal or source your `~/.zshrc` file.\n"
printf "After that run "
