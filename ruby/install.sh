#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting rbenv/ruby-build installation'
require_brew

brew_install rbenv ruby-build

finish
