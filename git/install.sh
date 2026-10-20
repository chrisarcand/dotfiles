#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting git installation'
require_brew

brew_install git gh
brew_install git-delta # core.pager in gitconfig; git can't show diffs/logs without it

finish
