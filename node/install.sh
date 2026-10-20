#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting node installation'
require_brew

brew_install nvm

# nvm keeps installed Node versions here (see node/environment.zsh).
mkdir -p "$HOME/.nvm"

finish
