#!/bin/sh

DOTFILES_ROOT=~/.dotfiles

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f $DOTFILES_ROOT/git/gitconfig.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your GitHub author name?'
    read -e git_authorname
    user ' - What is your GitHub author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" $DOTFILES_ROOT/git/gitconfig.symlink.example > $DOTFILES_ROOT/git/gitconfig.symlink

    success 'gitconfig'
  fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

symlink_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    local topic_dir="$(dirname "$src")"
    local filename="$(basename "${src%.*}")"

    if [ -f "$topic_dir/.symlink_base" ]; then
      local base="$(cat "$topic_dir/.symlink_base")"
      dst="$HOME/$base/$filename"
      mkdir -p "$HOME/$base"

      # Clean up stale symlink at the old wrong location
      local stale="$HOME/.$filename"
      if [ "$stale" != "$dst" ] && [ -L "$stale" ]; then
        local stale_target="$(readlink "$stale")"
        case "$stale_target" in
          */.dotfiles/*)
            rm -f "$stale"
            success "cleaned up stale symlink $stale"
            ;;
        esac
      fi
    else
      dst="$HOME/.$filename"
    fi

    link_file "$src" "$dst"
  done

  # Special case: /bin is a direct symlink (bin, not .bin)
  link_file "$DOTFILES_ROOT/bin" "$HOME/bin"
}

setup_gitconfig
symlink_dotfiles

# Initialize git submodules (plugins)
info 'initializing submodules'
cd "$DOTFILES_ROOT"
git submodule update --init --recursive 2>/dev/null
success 'submodules'

# Install Homebrew if OSX
if [[ ("$OSTYPE" == "darwin"*) && (! $(which brew)) ]]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# find the installers and run them iteratively
find $DOTFILES_ROOT -mindepth 2 -not -path "$DOTFILES_ROOT/_plugins/*" -name install.sh -exec "{}" \;

echo ''
echo 'Installation complete!'
