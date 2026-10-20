#!/bin/bash
#
# Ghostty
#
# Installs the Ghostty terminal emulator.

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting ghostty installation'
require_brew

brew_install_cask ghostty /Applications/Ghostty.app

finish
