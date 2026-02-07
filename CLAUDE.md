# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⚠️ CRITICAL SECURITY WARNING ⚠️

**THIS REPOSITORY IS PUBLIC ON GITHUB!**

**NEVER, EVER COMMIT:**
- Access tokens, API keys, or credentials of any kind
- Private email addresses or personal information
- AWS credentials, GitHub tokens, or OAuth secrets
- Anything that appears sensitive or private

**ALWAYS:**
- Check for sensitive data before any git commit
- Use `.example` files for configurations that may contain secrets
- Keep actual secrets in `.gitignore`d files like `~/.private-zshrc`
- Sanitize any private information before copying to `.example` files

When modifying configurations like `git/gitconfig.symlink` or `claude/settings.json.symlink`:
1. Make changes to the actual symlinked file
2. If it has a corresponding `.example` file (e.g., `gitconfig.symlink.example`), copy the changes there
3. **SANITIZE any private information** in the `.example` file (replace with placeholders like `AUTHORNAME`, `AUTHOREMAIL`)
4. Verify no secrets are present before committing

## Repository Overview

This is a personal dotfiles repository for macOS using a topic-based organizational scheme. Configuration files are organized by topic (git, zsh, zed, tmux, etc.) and automatically symlinked to appropriate locations during installation.

## Installation

```bash
# Clone with submodules (oh-my-zsh, tmux plugins)
git clone --recursive git@github.com:chrisarcand/dotfiles.git ~/.dotfiles

# Run main installer
~/.dotfiles/install.sh
```

The install script:
1. Sets up git configuration (prompts for name/email from gitconfig.symlink.example)
2. Symlinks all `*.symlink` files to appropriate locations
3. Initializes git submodules in `_plugins/`
4. Installs Homebrew if not present
5. Runs topic-specific `install.sh` scripts

## Topic-Based Organization

Each topic directory (git/, zsh/, zed/, etc.) follows these conventions:

- **`*.symlink`** - Symlinked to `$HOME/.filename` (or custom location via `.symlink_base`)
- **`*.symlink.example`** - Template for `.symlink` files (with secrets/personal info as placeholders)
- **`.symlink_base`** - Specifies alternate symlink target directory (e.g., `zed/.symlink_base` contains `.config/zed`)
- **`*.zsh`** - Sourced into zsh environment
- **`path.zsh`** - Loaded first, used to set up PATH
- **`completion.zsh`** - Loaded last, sets up autocomplete
- **`install.sh`** - Topic-specific installation commands

Available topics: `bin/`, `claude/`, `docker/`, `ghostty/`, `git/`, `golang/`, `node/`, `postgres/`, `pry/`, `ruby/`, `system/`, `terraform/`, `tmux/`, `zed/`, `zsh/`

## Key Configuration Files

**Shell:**
- `zsh/zshrc.symlink` - Main zsh configuration, loads oh-my-zsh and all topic `*.zsh` files
- `zsh/aliases.zsh` - Shell aliases
- `zsh/claude.zsh` - Claude Code CLI integration
- `zsh/environment.zsh` - Environment variables

**Git:**
- `git/gitconfig.symlink` - Git configuration with extensive aliases (gitignored, generated from .example)
- `git/gitconfig.symlink.example` - Template with placeholders for name/email
- Uses `delta` as the pager (navigate with `n`/`N`)
- Uses `zed -w` as the editor
- Common aliases: `s` (status), `cm` (commit), `br` (branch), `co` (checkout), `lg` (log graph)
- Full list at git/gitconfig.symlink:65-80

**Zed Editor:**
- `zed/settings.json.symlink` - Editor settings (may contain private info, has .example)
- `zed/settings.json.symlink.example` - Sanitized template
- `zed/keymap.json.symlink` - Custom keybindings
- Uses vim mode with `,` as the leader key
- `ctrl-a z` for zoom (tmux-style prefix)
- `ctrl-h/j/k/l` for pane navigation
- `shift-cmd-j` for terminal panel toggle

**Claude Code:**
- `claude/settings.json.symlink` - Claude Code CLI settings at `~/.claude/settings.json`
- `claude/CLAUDE.md.symlink` - User-level instructions at `~/.claude/CLAUDE.md`
- `claude/statusline.sh` - Custom statusline script

**Custom Scripts (`bin/`):**
- Added to PATH automatically
- Git utilities: `git-aicm`, `git-amend`, `git-autofixup`, `git-pause`, `git-resume`, `git-where`, `git-where-pr`
- Docker utilities: `clean-docker`, `docker-nuke`
- System utilities: `external-ip`, `internal-ip`, `wifi-pass`, `yank`
- Directory is gitignored by default; scripts must be added with `git add -f bin/script-name`

## Working with Dotfiles

### Adding New Configuration

1. Create topic directory if needed: `mkdir newtopic/`
2. Add configuration files with `.symlink` suffix
3. If the file may contain secrets, add it to `.gitignore` and create a `.symlink.example` with placeholders
4. Optionally add `.symlink_base` if symlinks should go to custom location
5. Add `path.zsh`, `*.zsh`, or `completion.zsh` as needed
6. Add `install.sh` if installation steps are required
7. Re-run `install.sh` to activate changes

### Modifying Existing Configuration

Files ending in `.symlink` are the source files in the repository. When editing them:

1. Edit the `.symlink` file directly
2. If a `.symlink.example` exists, update it too:
   - Copy the changes from `.symlink` to `.symlink.example`
   - **SANITIZE private information** (replace with `PLACEHOLDER` values)
   - Verify no secrets remain
3. Commit both files if appropriate

### Testing Changes

```bash
# Reload zsh configuration
source ~/.zshrc

# Verify git configuration
git config --list

# Test Zed configuration (restart Zed)
```

### Private Configuration

- Private/sensitive configuration goes in `~/.private-zshrc` (not tracked, gitignored)
- This file is sourced at the end of `zshrc.symlink`
- Use for environment variables like `GITHUB_TOKEN`, `USE_CLAUDE_BEDROCK`, etc.
- Never reference actual secret values in tracked files

## Git Workflow

The repository uses standard git workflows:
- Main branch: `master`
- Current state: clean working tree
- **Always review changes for sensitive data before committing**
- Common workflow: edit configs → sanitize → commit → push

Submodules are in `_plugins/`:
- `oh-my-zsh` - Shell framework
- Various tmux plugins

Update submodules with:
```bash
git submodule update --init --recursive
```

## Architecture Notes

- Zsh configuration loading order (defined in zsh/zshrc.symlink:46-83):
  1. oh-my-zsh initialization
  2. All `path.zsh` files
  3. All other `*.zsh` files (except path and completion)
  4. Autocomplete initialization
  5. All `completion.zsh` files
  6. Legacy config and private config

- PATH is hardcoded initially to prevent tmux from appending duplicates on reload
- Homebrew is added to PATH early so other `path.zsh` files can use it (e.g., for rbenv init)

## Common Tasks

**Modify Git Aliases:**
Edit `git/gitconfig.symlink` starting at line 65, then update `git/gitconfig.symlink.example` with sanitized version

**Add New Shell Alias:**
Add to `zsh/aliases.zsh`

**Add New Bin Script:**
1. Create script in `bin/`
2. Make executable: `chmod +x bin/script-name`
3. Add to git: `git add -f bin/script-name`
4. Review for sensitive data before committing

**Update Zed Keybindings:**
Edit `zed/keymap.json.symlink`

**Modify Claude Code Settings:**
Edit `claude/settings.json.symlink`, then sanitize and copy to `settings.json.symlink.example`

## Files in .gitignore

Critical files excluded from version control:
- `git/gitconfig.symlink` (generated from .example during install)
- `zed/settings.json.symlink` (has .example version)
- `bin/*` (except explicitly added with `git add -f` and `*.md` files)
- Any file containing actual credentials, tokens, or private information
