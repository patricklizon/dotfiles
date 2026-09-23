#!/usr/bin/env zsh
set -uo pipefail

repo_dir="${0:A:h}"
steps=(brew zsh omz node ssh git zed tmux aerospace)
completed=()
skipped=()
failed=()
optional_skipped=()
answer=""

usage() {
	printf 'Usage: %s [--plan]\n' "$0"
}

preview_link() {
	local source=$1 destination=$2

	if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
		return
	fi

	if [[ -e "$destination" || -L "$destination" ]]; then
		printf '  Back up and link: %s\n' "$destination"
	else
		printf '  Create link:      %s\n' "$destination"
	fi
}

show_plan() {
	printf 'Homebrew packages and apps:\n'
	"${repo_dir}/brew/install.sh" --plan || return 1
	printf '\nConfiguration links:\n'
	preview_link "${repo_dir}/zsh/.zshrc" "${HOME}/.zshrc"
	for name in .gitconfig .gitignore; do
		preview_link "${repo_dir}/git/${name}" "${HOME}/${name}"
	done
	for name in settings.json keymap.json tasks.json snippets; do
		preview_link "${repo_dir}/zed/${name}" "${HOME}/.config/zed/${name}"
	done
	preview_link "${repo_dir}/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
	preview_link "${repo_dir}/aerospace/default-config.toml" "${HOME}/.aerospace.toml"
	for name in aliases exports functions bind; do
		preview_link "${repo_dir}/omz/${name}.zsh" "${HOME}/.oh-my-zsh/custom/${name}.zsh"
	done
	printf '\nAlso configures Node LTS, Git identity, and optionally SSH.\n'
	printf 'Existing files listed above are kept in unique backup directories.\n'
}

ask() {
	local prompt=$1
	printf '%s' "$prompt"
	answer=""
	IFS= read -r answer || {
		printf '\nInput closed.\n' >&2
		return 1
	}
}

ensure_command_line_tools() {
	if /usr/bin/xcode-select -p &> /dev/null; then
		return 0
	fi

	printf '\nInstalling Xcode Command Line Tools. Complete the macOS dialog to continue.\n'
	/usr/bin/xcode-select --install || true
	while ! /usr/bin/xcode-select -p &> /dev/null; do
		ask 'Press Enter to check again, or type abort: ' || return 1
		if [[ "$answer" == abort ]]; then
			return 1
		fi
	done
}

activate_homebrew() {
	local brew_bin shell_environment
	if command -v brew &> /dev/null; then
		brew_bin=$(command -v brew)
	elif [[ -x /opt/homebrew/bin/brew ]]; then
		brew_bin=/opt/homebrew/bin/brew
	elif [[ -x /usr/local/bin/brew ]]; then
		brew_bin=/usr/local/bin/brew
	else
		return 1
	fi

	shell_environment=$("$brew_bin" shellenv) || return 1
	eval "$shell_environment"
}

run_step() {
	local step=$1 number=$2

	while true; do
		printf '\n[%d/%d] %s\n' "$number" "${#steps[@]}" "$step"
		if "${repo_dir}/bin/run.sh" install "$step"; then
			if [[ "$step" != brew ]] || activate_homebrew; then
				completed+=("$step")
				return 0
			fi
		fi

		printf '%s failed. Fix the issue, then retry this step.\n' "$step" >&2
		if [[ ! -t 0 ]]; then
			failed+=("$step")
			return 1
		fi

		while true; do
			if ! ask 'Retry, skip, or abort? [r/s/a] '; then
				failed+=("$step")
				return 2
			fi
			case "$answer" in
				r|R|'') break ;;
				s|S) skipped+=("$step"); return 1 ;;
				a|A) failed+=("$step"); return 2 ;;
			esac
		done
	done
}

summary() {
	printf '\nSetup summary\n'
	if (( ${#completed[@]} )); then
		printf 'Completed: %s\n' "${(j:, :)completed}"
	else
		printf 'Completed: none\n'
	fi
	if (( ${#optional_skipped[@]} )); then
		printf 'Optional:  %s skipped by choice\n' "${(j:, :)optional_skipped}"
	fi
	if (( ${#skipped[@]} )); then
		printf 'Skipped:   %s\n' "${(j:, :)skipped}"
	fi
	if (( ${#failed[@]} )); then
		printf 'Failed:    %s\n' "${(j:, :)failed}"
	fi
	if (( ! ${#skipped[@]} && ! ${#failed[@]} )); then
		printf 'Restart your terminal. Launch Docker Desktop once before using Ix.\n'
	fi
}

main() {
	if (( $# > 1 )); then
		usage >&2
		return 2
	fi
	case "${1:-}" in
		--plan) show_plan; return ;;
		--help|-h) usage; return ;;
		'') ;;
		*) usage >&2; return 2 ;;
	esac
	show_plan || return 1
	if [[ ! -t 0 ]]; then
		printf '\nRun this installer in an interactive terminal.\n' >&2
		return 2
	fi
	if [[ "$(uname -s)" != Darwin ]]; then
		printf '\nThis installer requires macOS.\n' >&2
		return 2
	fi

	local configure_ssh=true result number=0
	printf '\n'
	ask 'Proceed with setup? [y/N] ' || return 2
	case "$answer" in
		y|Y|yes|YES) ;;
		*) printf 'Setup cancelled.\n'; return 0 ;;
	esac

	ask 'Configure SSH key and Git signing? [Y/n] ' || return 2
	case "$answer" in
		n|N|no|NO) configure_ssh=false ;;
	esac
	ensure_command_line_tools || {
		printf 'Command Line Tools are required before setup can continue.\n' >&2
		return 1
	}

	for step in "${steps[@]}"; do
		(( number += 1 ))
		if [[ "$step" == ssh && "$configure_ssh" == false ]]; then
			printf '\n[%d/%d] ssh skipped by choice\n' "$number" "${#steps[@]}"
			optional_skipped+=(ssh)
			continue
		fi

		run_step "$step" "$number"
		result=$?
		if (( result == 2 )) || [[ "$step" == brew && $result -ne 0 ]]; then
			break
		fi
	done

	summary
	(( ${#skipped[@]} == 0 && ${#failed[@]} == 0 ))
}

main "$@"
