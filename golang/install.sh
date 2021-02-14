#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] starting golang installation\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  git clone https://github.com/syndbg/goenv.git ~/.goenv
fi
