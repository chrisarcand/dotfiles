#!/bin/bash

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'installing misc system packages'
require_brew

# A code-searching tool similar to ack, but faster.
# brew_install the_silver_searcher

# Convenient for webhook/VCS work
brew_install_cask ngrok

# Thoughtbot's pick (fuzzy-select anything); now in homebrew/core. The old
# thoughtbot/formulae tap is removed by the main install.sh.
brew_install pick

# Pin the postgres major version so postgres/path.zsh points at the right place.
brew_install memcached postgresql@18
brew_service_start memcached postgresql@18

brew_install openssl
brew_install wget
brew_install readline # See https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X
brew_install cmake

finish
