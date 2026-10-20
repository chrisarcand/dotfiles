#!/bin/bash
#
# Installs these dotfiles. Safe to re-run at any time: every step checks
# whether it's already done and skips it if so.

DOTFILES_ROOT="$HOME/.dotfiles"

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "These dotfiles only support macOS."
  exit 1
fi

# shellcheck source=lib/install_helpers.sh
. "$DOTFILES_ROOT/lib/install_helpers.sh"

echo ''

# Ask for a value until a non-empty one is given. Exits if stdin is closed.
# Runs inside $(...), so all messages go to stderr; only the answer is captured.
prompt_required () {
  local question=$1 answer=

  while [ -z "$answer" ]; do
    user "$question" >&2
    if ! read -r -e answer; then
      echo '' >&2
      fail "no input received; aborting" >&2
      exit 1
    fi
  done

  printf '%s' "$answer"
}

setup_gitconfig () {
  local gitconfig="$DOTFILES_ROOT/git/gitconfig.symlink"

  if [ -f "$gitconfig" ]; then
    success 'gitconfig already set up'
    return
  fi

  info 'setup gitconfig'

  local git_credential='osxkeychain'
  local git_authorname git_authoremail

  git_authorname="$(prompt_required ' - What is your GitHub author name?')" || exit 1
  git_authoremail="$(prompt_required ' - What is your GitHub author email?')" || exit 1

  # Escape characters that are special in a sed replacement (\ & and the | delimiter).
  git_authorname="$(printf '%s' "$git_authorname" | sed -e 's/[\\&|]/\\&/g')"
  git_authoremail="$(printf '%s' "$git_authoremail" | sed -e 's/[\\&|]/\\&/g')"

  # Write to a temp file first so an interrupted run never leaves a partial
  # gitconfig behind (which would cause the next run to skip this step). The
  # temp file lives outside the repo so personal info can't be committed.
  local tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/gitconfig.XXXXXX")" || { fail 'could not create temp file'; exit 1; }

  if sed -e "s|AUTHORNAME|$git_authorname|g" \
         -e "s|AUTHOREMAIL|$git_authoremail|g" \
         -e "s|GIT_CREDENTIAL_HELPER|$git_credential|g" \
         "$gitconfig.example" > "$tmp" \
     && mv "$tmp" "$gitconfig"
  then
    success 'gitconfig'
  else
    rm -f "$tmp"
    fail 'could not write gitconfig'
    exit 1
  fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$(readlink "$dst")" == "$src" ]
    then
      success "already linked $dst"
      return
    fi

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

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
    if ln -s "$1" "$2"; then
      success "linked $1 to $2"
    else
      fail "could not link $1 to $2"
    fi
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

init_submodules () {
  info 'initializing submodules'
  if git -C "$DOTFILES_ROOT" submodule update --init --recursive; then
    success 'submodules'
  else
    fail 'could not initialize submodules'
  fi
}

install_homebrew () {
  if ensure_brew_on_path; then
    success 'Homebrew already installed'
  else
    info 'installing Homebrew'

    # The Homebrew installer needs sudo. In NONINTERACTIVE mode it can't prompt
    # for a password itself, so cache sudo credentials up front.
    sudo -v || { fail 'sudo is required to install Homebrew'; exit 1; }

    if NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
       && ensure_brew_on_path
    then
      success 'Homebrew installed'
    else
      # Every topic installer depends on Homebrew; nothing else can proceed.
      fail 'Homebrew installation failed'
      exit 1
    fi
  fi

  # Remove taps that are obsolete or untrusted. An untrusted tap makes every
  # later brew command print a long warning, so do this before any installer.
  # - thoughtbot/formulae: pick now lives in homebrew/core
  # - homebrew/services: deprecated; `brew services` is built in
  brew_untap thoughtbot/formulae
  brew_untap homebrew/services
}

run_topic_installers () {
  local installer topic installers

  # Collect the list first so installers don't read from find's output on stdin.
  installers="$(find "$DOTFILES_ROOT" -mindepth 2 -maxdepth 2 -name install.sh -not -path "$DOTFILES_ROOT/_plugins/*" | sort)"

  for installer in $installers; do
    topic="$(basename "$(dirname "$installer")")"

    # Run through bash explicitly so a missing executable bit or shebang
    # can't silently skip a topic.
    if ! bash "$installer"; then
      failed_topics="$failed_topics $topic"
    fi
  done
}

check_command_line_tools () {
  info 'checking for Command Line Tools updates'
  # Use Homebrew's check: `softwareupdate` often doesn't list newer CLT releases.
  if brew doctor check_clt_up_to_date >/dev/null 2>&1; then
    success 'Command Line Tools are up to date'
  else
    warn 'A newer Command Line Tools release is available. Run `brew doctor check_clt_up_to_date` for update instructions.'
  fi
}

failed_topics=

setup_gitconfig
symlink_dotfiles
init_submodules
install_homebrew
run_topic_installers
echo ''
check_command_line_tools

echo ''
if [ -n "$failed_topics" ] || [ "$_install_failures" -gt 0 ]; then
  if [ -n "$failed_topics" ]; then
    fail "Installation finished with errors in:$failed_topics"
  else
    fail 'Installation finished with errors (see above)'
  fi
  echo '         Fix the errors above and re-run ~/.dotfiles/install.sh; completed steps are skipped.'
  exit 1
fi

success 'Installation complete!'
