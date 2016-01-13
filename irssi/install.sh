#!/bin/sh

echo ""
printf "\r  [ \033[00;34m..\033[0m ] installing irssi\n"

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install irssi
elif [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  sudo dnf install --assumeyes irssi
fi

echo ""
printf "\r  [ \033[00;34m..\033[0m ] symlinking irssi plugins\n"

# TODO: Loop through the scripts instead; check existence first
ln -s $DOTFILES_ROOT/irssi/irssi.symlink/scripts/xchatnickcolor.pl $DOTFILES_ROOT/irssi/irssi.symlink/scripts/autorun/xchatnickcolor.pl
ln -s $DOTFILES_ROOT/irssi/irssi.symlink/scripts/nicklist.pl $DOTFILES_ROOT/irssi/irssi.symlink/scripts/autorun/nicklist.pl
