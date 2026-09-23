#!/usr/bin/env zsh
set -euo pipefail

taps=(
	"ix-infrastructure/ix https://github.com/ix-infrastructure/Ix"
)

packages=(
	fnm # https://github.com/schniz/fnm
	fzf # https://github.com/junegunn/fzf
	git
	glow # https://github.com/charmbracelet/glow
	gnupg # https://github.com/gpg/gnupg
	gron # https://github.com/tomnomnom/gron
	jq # https://github.com/jqlang/jq
	ripgrep # https://github.com/BurntSushi/ripgrep
	shellcheck # https://github.com/koalaman/shellcheck
	tealdeer # https://github.com/dbrgn/tealdeer
	tmux # https://github.com/tmux/tmux/wiki
	dagger/tap/container-use # https://container-use.com
	cloudflared # https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/downloads/
	rtk # https://github.com/rtk-ai/rtk
	ix # https://github.com/ix-infrastructure/Ix
)

fonts=(
	font-fira-code
	font-hack-nerd-font
	font-jetbrains-mono
)

apps=(
	docker-desktop # https://formulae.brew.sh/cask/docker-desktop
	firefox
	google-chrome
	cryptomator # https://github.com/cryptomator/cryptomator
	ghostty # https://github.com/ghostty-org/ghostty
	keepassxc # https://github.com/keepassxreboot/keepassxc
	proxyman # https://github.com/proxymanapp/proxyman
	rectangle # https://github.com/rxhanson/rectangle
	signal # https://github.com/signalapp/Signal-Desktop
	stats # https://github.com/exelban/stats
	transmission # https://github.com/transmission/transmission
	utm # https://github.com/utmapp/UTM
	zed # https://github.com/zed-industries/zed
	nikitabobko/tap/aerospace # https://github.com/nikitabobko/AeroSpace
	codex # https://github.com/openai/codex
)

casks=(${fonts[@]} ${apps[@]})

is_already_installed_with_brew() {
	local pkg=$1
	local install_type=${2:-}
	local package_name=${pkg##*/}

	if [[ "$install_type" == "--cask" ]]; then
		brew list --cask --versions "$package_name" &> /dev/null
	else
		brew list --formula --versions "$package_name" &> /dev/null
	fi

}

install_taps() {
	local tap_spec tap_name tap_url

	for tap_spec in "${taps[@]}"; do
		tap_name=${tap_spec%% *}
		tap_url=${tap_spec#* }

		if brew tap | grep -Fx "$tap_name" > /dev/null; then
			printf '%s is already tapped.\n' "$tap_name"
		else
			printf '%s is not tapped. Tapping now...\n' "$tap_name"
			brew tap "$tap_name" "$tap_url"
		fi
	done

}

install_with_brew() {
	local pkg=$1
	local is_cask=${2:-}

	# Check if Homebrew is installed
	if ! command -v brew &> /dev/null; then
		echo "Homebrew is not installed. Please install Homebrew first.\n"
		return 1
	fi

	if is_already_installed_with_brew "$pkg" "$is_cask"; then
		printf '%s is already installed.\n' "$pkg"
	else
		printf '%s is not found. Installing now...\n' "$pkg"
		if [ "$is_cask" = "--cask" ]; then
			brew install --cask "$pkg"
			printf 'The cask %s has been successfully installed.\n' "$pkg"
		else
			brew install "$pkg"
			printf 'The formula %s has been successfully installed.\n' "$pkg"
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
	if ! command -v brew &> /dev/null; then
		printf "\nInstalling the brew package manager\n"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

		if [[ -x /opt/homebrew/bin/brew ]]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		elif [[ -x /usr/local/bin/brew ]]; then
			eval "$(/usr/local/bin/brew shellenv)"
		fi
	fi

	install_taps
	install_packages
	install_casks
	cleanup

	printf "\nRestart your terminal or source your ~/.zshrc file.\n"
}

main
