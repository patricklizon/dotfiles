# Dotfiles

My macOS dotfiles and setup scripts.

## Setup

Run the installer once from an interactive terminal:

```sh
./install.sh
```

It previews packages and configuration links before changing anything. Existing files
are backed up, and a failed step can be retried in the same run after you resolve the
issue. SSH setup is optional. The installer starts the Xcode Command Line Tools
installation if they are missing and waits for it to finish.

To inspect the plan without making changes, run `./install.sh --plan`.

After setup, restart your terminal and launch Docker Desktop once before using Ix or
other tools that need a Docker engine.

Homebrew cleanup is separate from installation. Run `./brew/cleanup.sh` when you want
to remove unused formulae and cached downloads.
