#!/bin/sh
#
# Zed
#
# This installs Zed editor

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "  Homebrew not found. Please install Homebrew first."
  exit 1
fi

# Install Zed if not already installed
if ! command -v zed >/dev/null 2>&1; then
  echo "  Installing Zed editor..."
  brew install zed
else
  echo "  Zed already installed"
fi

exit 0
