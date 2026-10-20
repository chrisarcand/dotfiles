#!/bin/bash
#
# OpenCode

. "$(dirname "$0")/../lib/install_helpers.sh"

echo ''
info 'starting opencode installation'
require_brew

brew_install anomalyco/tap/opencode

opencode_config_dir="$HOME/.config/opencode"
opencode_skills_src="$DOTFILES_ROOT/opencode/skills.symlink"
opencode_skills_dst="$opencode_config_dir/skills"

mkdir -p "$opencode_config_dir"

if [ ! -e "$opencode_skills_dst" ] && [ ! -L "$opencode_skills_dst" ] && [ -d "$opencode_skills_src" ]; then
  if ln -s "$opencode_skills_src" "$opencode_skills_dst"; then
    success "linked $opencode_skills_src to $opencode_skills_dst"
  else
    fail "could not link $opencode_skills_dst"
  fi
fi

finish
