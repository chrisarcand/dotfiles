#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] starting tmux installation\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX
  brew install tmux
elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  # Fedora, RHEL, or CentOS
  sudo dnf install --assumeyes tmux
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "FAILED!"
  echo "No config for the current OS/distribution found."
  echo "Add installation steps to $DIR/$(basename $0)"
  exit 1
fi
