#!/usr/bin/env zsh
set -euo pipefail

if ! command -v brew &> /dev/null; then
	printf 'Homebrew is not installed.\n' >&2
	exit 1
fi

brew autoremove --verbose
brew cleanup --prune=all
