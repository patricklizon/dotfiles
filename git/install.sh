#!/usr/bin/env zsh
set -e

source "${0:A:h:h}/constants.sh"

DIR="${HOME}/"
PWD_PATH="${0:A:h}/"
LOCAL_GIT_CONFIG="${HOME}/.gitconfig.local"

copy_gitconfig_local() {
	if [ ! -f "${LOCAL_GIT_CONFIG}" ]; then
		cp "${PWD_PATH}/.gitconfig.local" "${LOCAL_GIT_CONFIG}"

		sed -i '' "s|GIT_SIGNKEY|~/.ssh/id_${SSH_KEY_TYPE}.pub|" "${LOCAL_GIT_CONFIG}"
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
