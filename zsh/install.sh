#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting zsh installation'
require_brew

brew_install zsh

finish
