#!/bin/bash
#
# Docker
#
# Installs Docker Desktop.

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting docker installation'
require_brew

brew_install_cask docker-desktop /Applications/Docker.app

finish
