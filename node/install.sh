#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] starting node installation\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX
  brew install node
  npm install --global yarn
elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  # Fedora, RHEL, or CentOS
  # vim in Fedora is compiled without any X support in order to minimize the number of dependencies it has.
  # Use gvim instead, in the vim-X11 package.
  sudo dnf install --assumeyes vim-X11
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "FAILED!"
  echo "No config for the current OS/distribution found."
  echo "Add installation steps to $DIR/$(basename $0)"
  exit 1
fi
