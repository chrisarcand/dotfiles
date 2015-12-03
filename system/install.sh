#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] installing misc system packages\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX
  brew cask install seil # Key mapper; Remap CapsLock->ESC with this
fi
