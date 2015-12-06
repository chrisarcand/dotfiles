#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] installing misc system packages\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Key mapper; Remap CapsLock->ESC with this
  brew cask install seil

  # For arranging windows Windows/Fedora style (opt+arrows for half screen, etc)
  brew cask install shiftit

  # A code-searching tool similar to ack, but faster.
  brew install the_silver_searcher

  # Thoughtbot's awesome CLI tool for fuzzy searching basically anything
  brew tap thoughtbot/formulae
  brew install pick

  # A maintained version of ctags
  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags

  # Because launchctl sucks
  brew install reattach-to-user-namespace --with-wrap-launchctl # Required to run services in tmux
  brew tap homebrew/services # Now maintained at https://github.com/Homebrew/homebrew-services

  brew install memcached
  brew install postgresql
  brew install openssl
elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") && (! $(which psql))  ]]; then
  sudo dnf install --assumeyes postgresql-devel postgresql-server
  sudo systemctl enable postgresql
  sudo /usr/bin/postgresql-setup --initdb
  sudo systemctl start postgresql
fi
