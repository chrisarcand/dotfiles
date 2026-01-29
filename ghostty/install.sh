#!/bin/sh
#
# Ghostty
#
# This installs Ghostty terminal emulator

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "  Homebrew not found. Please install Homebrew first."
  exit 1
fi

# Install Ghostty if not already installed
if ! command -v ghostty >/dev/null 2>&1; then
  echo "  Installing Ghostty terminal emulator..."
  brew install --cask ghostty
else
  echo "  Ghostty already installed"
fi

exit 0
