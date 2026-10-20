#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting tfenv installation'

git_clone_once https://github.com/tfutils/tfenv.git "$HOME/.tfenv"

finish
