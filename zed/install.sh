#!/bin/bash
#
# Zed
#
# Installs the Zed editor.

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting zed installation'
require_brew

# Homebrew generates PowerShell completions for Zed's CLI on install and fails
# with "Operation not permitted" if it has to create this directory itself.
mkdir -p "$(brew --prefix)/share/pwsh"

brew_install_cask zed /Applications/Zed.app

finish
