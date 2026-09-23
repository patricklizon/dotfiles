#!/usr/bin/env zsh
set -e

source "${0:A:h:h}/constants.sh"

DIR="${HOME}/"
PWD_PATH="${0:A:h}/"
LOCAL_GIT_CONFIG="${HOME}/.gitconfig.local"

copy_gitconfig_local() {
	if [ ! -f "${LOCAL_GIT_CONFIG}" ]; then
		local email="${DOTFILES_GIT_EMAIL:-}"
		while [[ -z "$email" ]]; do
			if [[ ! -t 0 ]]; then
				printf 'Set DOTFILES_GIT_EMAIL for non-interactive setup.\n' >&2
				return 1
			fi
			printf 'Git email: '
			IFS= read -r email
		done

		local temp_config
		temp_config=$(mktemp "${LOCAL_GIT_CONFIG}.XXXXXX")
		if ! cp "${PWD_PATH}/.gitconfig.local" "$temp_config" ||
			! git config -f "$temp_config" user.email "$email"; then
			rm -f "$temp_config"
			return 1
		fi
		if [[ -f "${SSH_KEY_PATH}" ]]; then
			if ! git config -f "$temp_config" user.signingkey "${SSH_KEY_PATH}"; then
				rm -f "$temp_config"
				return 1
			fi
		else
			if ! git config -f "$temp_config" commit.gpgsign false; then
				rm -f "$temp_config"
				return 1
			fi
		fi
		mv "$temp_config" "${LOCAL_GIT_CONFIG}"
	fi
}

create_symlinks() {
	local backup_dir=""
	files=(
		.gitconfig
		.gitignore
	)

	for file in "${files[@]}"; do
		target="${DIR}${file}"
		local source="${PWD_PATH}${file}"

		if [[ -L "${target}" && "$(readlink "${target}")" == "${source}" ]]; then
			continue
		fi

		if [[ -e "${target}" || -L "${target}" ]]; then
			if [[ -z "${backup_dir}" ]]; then
				backup_dir=$(mktemp -d "${HOME}/.dotfiles-backup.XXXXXX")
			fi
			mv "${target}" "${backup_dir}/${file}"
			printf 'Backed up %s to %s\n' "${target}" "${backup_dir}"
		fi

		ln -s "${source}" "${target}"
	done
}

main() {
	echo "Setting up git..."
	copy_gitconfig_local
	create_symlinks
}

main
