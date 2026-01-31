# Chris Arcand's dotfiles

Your dotfiles are how you personalize your system. These are mine.

This contains my own configurations for git, zed, zsh using oh-my-zsh, ruby, pry, tmux, ghostty, and more.
The provided installer includes support for the following OS/distributions:

- MacOS

## What's Included

**Development Tools:**
- Git configuration with extensive aliases and hooks
- Ruby/rbenv environment
- Node.js/nvm environment
- Go/goenv environment
- Terraform/tfenv environment
- Docker configuration

**Editors & Terminal:**
- Zed editor (vim-mode keybindings)
- Ghostty terminal emulator
- Tmux with vim-style navigation
- Pry and IRB configurations for Ruby

**Shell:**
- Zsh with oh-my-zsh framework
- Custom aliases and functions
- Claude Code CLI integration

**Custom Scripts:**
- 20+ custom utilities in `bin/` (see `bin/README.md` for details)
- Git utilities including AI-powered commit messages
- Docker management scripts
- System utilities

## Installation

There is an install script to automatically symlink all the configuration files
to your home directory and install packages for supported operating systems.

```plaintext
$ git clone --recursive git@github.com:chrisarcand/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/install.sh
```

Note: Although the install script is quite good and will back up your own
existing dotfiles with nice prompts, I take no responsibility for your system.
Please be sure to back up your files appropriately before installation if
there's anything important that already exists.

You'll need to set up things like your default shell and fonts n' stuff in your terminal emulator yourself, after this installation.

### What Gets Installed

The install script will:
1. Set up git configuration (prompts for name/email)
2. Symlink all `.symlink` files to the appropriate location (see Organization below)
3. Initialize git submodules (oh-my-zsh, tmux plugins)
4. Install Homebrew (on macOS, if not already installed)
5. Run topic-specific install scripts found in each directory

Some tools with installers:
- `git/install.sh` - Git and GitHub CLI
- `zsh/install.sh` - Zsh shell
- `ruby/install.sh` - rbenv and ruby-build
- `node/install.sh` - nvm (Node version manager)
- `golang/install.sh` - goenv (Go version manager)
- `terraform/install.sh` - Terraform environment setup
- `tmux/install.sh` - Tmux terminal multiplexer
- `zed/install.sh` - Zed editor
- `ghostty/install.sh` - Ghostty terminal
- `docker/install.sh` - Docker Desktop
- `system/install.sh` - System packages via Homebrew
- `claude/install.sh` - Claude Code directory setup

### Security Notes

This repository follows security best practices:
- Secrets and credentials use environment variables (never hardcoded)
- Private configuration can be added via `~/.private-zshrc` (not tracked in git)
- Sensitive files are excluded via `.gitignore`
- Git hooks provide safety checks for pushes to non-personal repositories

**Optional Environment Variables:**
- `GITHUB_TOKEN` - Used by the GitHub MCP server configured in Claude Code settings
- `USE_CLAUDE_BEDROCK` - Set to `1` in `~/.private-zshrc` to use AWS Bedrock as the Claude provider
- AWS credentials should be configured via `~/.aws/config` (not in dotfiles)

Keep sensitive information out of tracked files. Use environment variables or the private config pattern.

### Organization

These files follow a topic-based organizational scheme originally popularized by Zach Holman.
The organization is as follows:

- **bin/**
  Anything in bin/ will get added to your $PATH and be made available everywhere.

- **\<topic\>/\*.zsh**
  Any files ending in .zsh get loaded into your environment.

- **\<topic\>/path.zsh**
  Any file named path.zsh is loaded first and is expected to
  setup $PATH or similar.

- **\<topic\>/completion.zsh**
  Any file named completion.zsh is loaded last and is
  expected to set up autocomplete.

- **\<topic\>/\*.symlink**
  Any files ending in `.symlink` get symlinked into your `$HOME` when you use the
  provided install script (e.g. `git/gitconfig.symlink` → `~/.gitconfig`).

- **\<topic\>/.symlink_base**
  If a topic directory contains a `.symlink_base` file, its contents specify
  the path (relative to `$HOME`) where that topic's `.symlink` files should be
  linked instead of the default `~/.<name>`. For example, `zed/.symlink_base`
  contains `.config/zed`, so `zed/settings.json.symlink` is linked to
  `~/.config/zed/settings.json`.

- **\_plugins/**
  This directory houses git submodules to properly version important external dependencies. I don't
  do this for all plugins, but make an exception for some things like oh-my-zsh and tmux plugins.

### Zed

Some time back I switched from vim/nvim to Zed. Many of the basic bindings emulate my old vim+tmux
setup, which originally came from [Maximum Awesome](https://github.com/square/maximum-awesome), the
set of dotfiles I originally started using with vim. `,` is the Vim leader key, and `ctrl-a z` is
the Tmux-style prefix.

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
