#!/bin/sh
#
# Docker
#
# This installs Docker Desktop

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "  Homebrew not found. Please install Homebrew first."
  exit 1
fi

# Install Docker Desktop if not already installed
if ! command -v docker >/dev/null 2>&1; then
  echo "  Installing Docker Desktop..."
  brew install --cask docker
  echo "  Note: You may need to start Docker Desktop from Applications after installation"
else
  echo "  Docker already installed"
fi

exit 0
