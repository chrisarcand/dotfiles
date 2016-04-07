#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] installing gnupg\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install gpg2 gpg-agent
elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  printf "\r  [ \033[00;34m..\033[0m ] gnupg should already been installed on this distro, skipping...\n"
fi


printf "\r  [ \033[00;34m..\033[0m ] WARNING: I AM LAZY AND HAVE NOT AUTOMATED THE CONFIG OF GNUPG AND GPG-AGENT\n"
printf "\r  [ \033[00;34m..\033[0m ] You should set .gnupg/gpg.conf to use-agent and maybe a custom timeout in gpg-agent.conf\n"
