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

# Create symlink for CLAUDE.md
if [ -f ~/.claude/CLAUDE.md ] && [ ! -L ~/.claude/CLAUDE.md ]; then
  echo "Backing up existing Claude CLAUDE.md..."
  mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup
fi

if [ ! -L ~/.claude/CLAUDE.md ]; then
  echo "Symlinking Claude CLAUDE.md..."
  ln -s $DOTFILES_ROOT/.claude/CLAUDE.md.symlink ~/.claude/CLAUDE.md
  echo "✓ Claude CLAUDE.md symlinked"
else
  echo "✓ Claude CLAUDE.md already symlinked"
fi

# Create symlink for agents directory
if [ -d ~/.claude/agents ] && [ ! -L ~/.claude/agents ]; then
  echo "Backing up existing Claude agents directory..."
  mv ~/.claude/agents ~/.claude/agents.backup
fi

if [ ! -L ~/.claude/agents ]; then
  echo "Symlinking Claude agents directory..."
  ln -s $DOTFILES_ROOT/.claude/agents.symlink ~/.claude/agents
  echo "✓ Claude agents directory symlinked"
else
  echo "✓ Claude agents directory already symlinked"
fi
