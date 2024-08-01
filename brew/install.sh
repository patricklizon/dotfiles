#!/usr/bin/env zsh
set -e

packages=(
	# gh # https://cli.github.com
	ack # https://github.com/samaaron/ack
	fnm # https://github.com/schniz/fnm
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
	firefox
	google-chrome
	iterm2 # https://github.com/gnachman/iterm2
	keepassxc # https://github.com/keepassxreboot/keepassxc
	proxyman # https://github.com/proxymanapp/proxyman
	rectangle # https://github.com/rxhanson/rectangle
	signal # https://github.com/signalapp/Signal-Desktop
	stats # https://github.com/exelban/stats
	transmission # https://github.com/transmission/transmission
	zed # https://github.com/zed-industries/zed
	utm # https://github.com/utmapp/UTM
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
	local pkg=$1
	local is_cask=$2

	# Check if Homebrew is installed
	if ! command -v brew &> /dev/null; then
		echo "Homebrew is not installed. Please install Homebrew first.\n"
		return 1
	fi

	if is_already_installed_with_brew "$pkg" "$is_cask"; then
		echo "$pkg is already installed.\n"
	else
		echo "$pkg is not found. Installing now...\n"
		if [ "$is_cask" = "--cask" ]; then
			if brew install --cask "$pkg"; then
				"The cask ${pkg} has been successfully installed.\n"
			else
				"Failed to install the cask $pkg.\n"
			fi
		else
			if brew install "$pkg"; then
				"The formula ${pkg} has been successfully installed.\n"
			else
				"Failed to install the formula $pkg.\n"
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
	echo "Cleaning up...\n"
	brew autoremove --verbose
	brew cleanup --prune=all
}

main() {
	if test ! $(which brew); then
		printf "\nInstalling the brew package manager\n"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	install_packages
	install_casks
	cleanup

	printf "\nRestart your terminal or source your ~/.zshrc file.\n"
}

main
