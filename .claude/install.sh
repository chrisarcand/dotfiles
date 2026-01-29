#!/bin/sh
#
# Claude settings symlink setup

DOTFILES_ROOT=~/.dotfiles

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Create symlink for settings.json
if [ -f ~/.claude/settings.json ] && [ ! -L ~/.claude/settings.json ]; then
  echo "Backing up existing Claude settings.json..."
  mv ~/.claude/settings.json ~/.claude/settings.json.backup
fi

if [ ! -L ~/.claude/settings.json ]; then
  echo "Symlinking Claude settings.json..."
  ln -s $DOTFILES_ROOT/.claude/settings.json.symlink ~/.claude/settings.json
  echo "✓ Claude settings.json symlinked"
else
  echo "✓ Claude settings.json already symlinked"
fi
