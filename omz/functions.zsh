killport() {
	if [[ $# -ne 1 || "$1" != <-> || "$1" -lt 1 || "$1" -gt 65535 ]]; then
		print -u2 'Usage: killport <port>'
		return 2
	fi

	local pids
	pids=$(lsof -nP -tiTCP:"$1" -sTCP:LISTEN) || return 1
	kill -TERM -- ${(f)pids}
}
