#!/bin/bash
#
# tmux
#
# Installs the tmux terminal multiplexer.

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting tmux installation'
require_brew

brew_install tmux

finish
