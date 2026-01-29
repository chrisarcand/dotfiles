#!/bin/sh
#
# tmux
#
# This installs tmux terminal multiplexer

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "  Homebrew not found. Please install Homebrew first."
  exit 1
fi

# Install tmux if not already installed
if ! command -v tmux >/dev/null 2>&1; then
  echo "  Installing tmux..."
  brew install tmux
else
  echo "  tmux already installed"
fi

exit 0
