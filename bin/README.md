# Custom Binaries and Scripts

This directory contains custom executable scripts and binaries used across the system.

## How This Directory Works

The `bin/` directory is in your `$PATH`, so anything here can be executed from anywhere.

**The directory is gitignored by default** (`bin/*` in `.gitignore`), which means:
- You can casually drop temporary tools, binaries, or one-off scripts here without worrying about accidentally committing them
- Your `~/bin` can contain both shared dotfiles scripts AND temporary local-only stuff
- Only scripts explicitly added with `git add -f` are tracked and shared

**To share a script in dotfiles:** `git add -f bin/your-script`

**Currently shared in git:**
- Curated shell scripts for git, docker, and system utilities
- Markdown documentation (`.md` files are excepted from gitignore via `!bin/*.md`)

## Script Categories

### Git Utilities
- `git-aicm` - AI-powered commit message generator using GitHub Copilot (see git-aicm.md for documentation)
- `git-amend` - Quick commit amending
- `git-autofixup` - Automatically create fixup commits
- `git-autosquash` - Automatically squash fixup commits
- `git-pause` / `git-resume` - Temporarily save and restore work in progress
- `git-where` - Show current branch and status information
- `git-where-pr` - Show PR information for current branch
- `git-related` - Find related files in git history
- `git-recently-checkout-branches` - List recently checked out branches
- `git-thanks` - Generate thank you messages for contributors
- `diff-highlight` - Enhanced diff highlighting (Perl script)

### Docker Utilities
- `clean-docker` - Clean up Docker containers and images
- `docker-nuke` - Aggressively remove all Docker resources
- `difn` - Docker-related utility

### System Utilities
- `external-ip` - Display your external IP address
- `internal-ip` - Display your internal IP address
- `wifi-pass` - Retrieve saved WiFi passwords
- `yank` - Copy command output to clipboard
- `intensify` - Image intensification utility
- `bundler-search` - Search for gems in bundle
- `generate-json-template` - Generate JSON templates (Ruby script)

### HashiCorp Internal Tools

These are internal HashiCorp development tools and are specific to HashiCorp engineering workflows:

- `tfarm` - Internal Terraform development tool
- `hcptblaster` - HCP Terraform load testing utility
- `heapcheck` - Heap memory analysis tool
- `hh` - HashiCorp helper utility
- `build-terraform-as-tool-version` - Build Terraform with specific version
- `hard-reset-tfcdev` / `nuketfcdev` - TFC development environment reset tools
- `heap_dump` - Generate heap dumps for debugging

### Terraform Tools
- `terraform-0.13.7` - Specific Terraform version binary
- `terraform-stacks` - Terraform Stacks prototype/development build
- `terragrunt` - Terragrunt infrastructure-as-code tool

### Other Tools
- `atlas-console` / `atlasshell` - Atlas (MongoDB) console wrappers

**Note:** Other tools may exist in your local `bin/` directory but are not tracked in git. The gitignore pattern allows you to keep temporary and local-only tools here without cluttering the shared dotfiles.

## Notes

- Most shell scripts (`.sh` files without extension) are executable and can be run directly
- Large binary executables are excluded from git tracking via `.gitignore`
- HashiCorp internal tools are specific to HashiCorp engineering workflows and may not be applicable outside that context
- Some utilities depend on external tools (git, docker, brew, etc.) being installed

## Usage

All scripts in this directory are automatically added to your `$PATH` by the dotfiles setup, so they can be invoked directly from anywhere in your shell.

Example:
```bash
# Generate an AI commit message
git-aicm

# Clean up Docker
clean-docker

# Get your external IP
external-ip
```
