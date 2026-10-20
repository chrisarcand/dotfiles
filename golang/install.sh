#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting golang installation'

git_clone_once https://github.com/syndbg/goenv.git "$HOME/.goenv"

finish
