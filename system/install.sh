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
fi
