#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] starting rbenv/ruby-build installation\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX
  brew install rbenv ruby-build
elif [[ ("$OSTYPE" == "linux-gnu") ]]; then
  sudo dnf install --assume-yes gcc openssl-devel readline-devel zlib-devel
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "FAILED!"
  echo "No config for the current OS/distribution found."
  echo "Add installation steps to $DIR/$(basename $0)"
  exit 1
fi
