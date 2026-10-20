#!/bin/bash
#
# Shared helpers for install.sh and every <topic>/install.sh.
#
# Source this file; don't execute it. Every helper is idempotent: if the thing
# is already installed/configured it reports OK and moves on, so the whole
# install can be re-run safely at any time.
#
# Topic scripts should call `finish` at the end, which exits non-zero if any
# helper reported a failure, so the main installer can report it.

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"

# Never stop to ask "Do you want to proceed with the installation? [y/n]".
export HOMEBREW_NO_ASK=1
export HOMEBREW_NO_ENV_HINTS=1

_install_failures=0

info () {
  printf "\r  [ \033[00;34m..\033[0m ] %b\n" "$1"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] %b\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %b\n" "$1"
}

warn () {
  printf "\r\033[2K  [\033[0;33mWARN\033[0m] %b\n" "$1"
}

# Records a failure but does not exit, so the remaining steps still run.
fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %b\n" "$1"
  _install_failures=$((_install_failures + 1))
}

# Exit the current script with a status reflecting any recorded failures.
finish () {
  if [ "$_install_failures" -gt 0 ]; then
    exit 1
  fi
  exit 0
}

# Make sure `brew` is on PATH. On a fresh machine Homebrew may be installed
# but not yet on PATH because no shell profile has been loaded.
ensure_brew_on_path () {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      eval "$("$candidate" shellenv)"
      return 0
    fi
  done

  return 1
}

# Exit the current topic script if Homebrew isn't available.
require_brew () {
  if ! ensure_brew_on_path; then
    fail "Homebrew not found; skipping"
    finish
  fi
}

# brew_install FORMULA...
brew_install () {
  local formula
  for formula in "$@"; do
    if brew list --formula --versions "$formula" >/dev/null 2>&1; then
      success "$formula already installed"
    elif brew install --formula --yes "$formula"; then
      success "installed $formula"
    else
      fail "could not install $formula"
    fi
  done
}

# brew_install_cask CASK [APP_PATH]
#
# APP_PATH (e.g. /Applications/Foo.app) lets us treat an app that was installed
# outside of Homebrew as already installed instead of failing on a conflict.
brew_install_cask () {
  local cask=$1 app=$2

  if brew list --cask "$cask" >/dev/null 2>&1; then
    success "$cask already installed"
  elif [ -n "$app" ] && [ -e "$app" ]; then
    success "$cask already installed at $app (not managed by Homebrew)"
  elif brew install --cask --yes "$cask"; then
    success "installed $cask"
  else
    fail "could not install $cask"
  fi
}

# brew_untap TAP - remove a tap if it's present.
brew_untap () {
  local tap=$1

  if ! brew tap | grep -qx "$tap"; then
    return 0
  fi

  if brew untap "$tap"; then
    success "removed tap $tap"
  else
    fail "could not remove tap $tap"
  fi
}

# brew_service_start SERVICE... - start a Homebrew service (and at login).
brew_service_start () {
  local service status
  for service in "$@"; do
    status="$(brew services list | awk -v name="$service" '$1 == name { print $2 }')"
    if [ "$status" = "started" ]; then
      success "$service service already running"
    elif brew services start "$service"; then
      success "started $service service"
    else
      fail "could not start $service service"
    fi
  done
}

# git_clone_once URL DIR
git_clone_once () {
  local url=$1 dir=$2

  if [ -d "$dir/.git" ]; then
    success "$dir already cloned"
  elif [ -e "$dir" ]; then
    fail "$dir exists but is not a git checkout; move it aside and re-run"
  elif git clone --quiet "$url" "$dir"; then
    success "cloned $url to $dir"
  else
    fail "could not clone $url"
  fi
}
