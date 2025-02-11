# randomly generated temporary directory for GnuPG (GNU Privacy Guard) operations
export GNUPGHOME=$(mktemp -d -t gnupg-$(date +%Y-%m-%d)-XXXXXXXXXX)
