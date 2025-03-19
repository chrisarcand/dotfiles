#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] installing misc system packages\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # A code-searching tool similar to ack, but faster.
  # brew install the_silver_searcher

  # Convenient for webhook/VCS work
  brew cask install ngrok

  # Thoughtbot's awesome CLI tool for fuzzy searching basically anything
  brew tap thoughtbot/formulae
  brew install pick

  # Because launchctl sucks
  # brew install reattach-to-user-namespace # Required to run services and working pasteboards in tmux
  brew tap homebrew/services # Now maintained at https://github.com/Homebrew/homebrew-services

  brew install memcached
  brew install postgresql
  brew install openssl
  brew install wget
  brew install readline # See https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X
  brew install cmake

elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  sudo dnf install --assumeyes autoconf automake # build tools


    make

  # Postgres
  if [[ ! $(which psql) ]]; then
    sudo dnf install --assumeyes postgresql-devel postgresql-server
    sudo systemctl enable postgresql
    sudo /usr/bin/postgresql-setup --initdb
    sudo systemctl start postgresql
  fi
fi
