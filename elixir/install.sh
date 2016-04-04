#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] starting elixir installation\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX
  brew install elixir
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "FAILED!"
  echo "No config for the current OS/distribution found."
  echo "Add installation steps to $DIR/$(basename $0)"
  exit 1
fi
