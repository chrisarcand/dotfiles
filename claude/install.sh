#!/bin/sh
#
# Claude Code

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

DOTFILES="$HOME/.dotfiles"
TARGET="$HOME/.claude/settings.json"

printf "Is this a work machine? [y/N] "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
  SOURCE="$DOTFILES/claude/settings.work.json"
  machine="work"
else
  SOURCE="$DOTFILES/claude/settings.personal.json"
  machine="personal"
fi

# Check if symlink already points to the correct file
if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
  echo "  settings.json already linked to $machine config, skipping."
else
  # Remove existing file or symlink
  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    rm "$TARGET"
  fi
  ln -s "$SOURCE" "$TARGET"
  echo "  Linked settings.json -> $machine config"
fi

exit 0
