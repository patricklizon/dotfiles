#!/usr/bin/env zsh
set -e

check_and_create_file() {
	local target=$1
	if [ ! -e "${target}" ]; then
		touch "${target}"
	fi
}

add_initializers() {
	local initializers=(
		'eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"'
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
	echo "Setting up zsh..."

	check_and_create_file "${HOME}/.secrets"
	check_and_create_file "${HOME}/.initializers"
	add_initializers

	local target="${PWD}/zsh/.zshrc"
	local destination="${HOME}/.zshrc"

	if [[ -L "$destination" && "$(readlink "$destination")" == "$target" ]]; then
		return
	fi

	if [[ -e "$destination" || -L "$destination" ]]; then
		local backup_dir
		backup_dir=$(mktemp -d "${HOME}/.dotfiles-backup.XXXXXX")
		mv "$destination" "${backup_dir}/.zshrc"
		printf 'Backed up %s to %s\n' "$destination" "$backup_dir"
	fi

	ln -s "$target" "$destination"
}

main
