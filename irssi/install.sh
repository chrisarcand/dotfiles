#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] installing irssi\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install irssi
elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  sudo dnf install --assumeyes irssi
fi
