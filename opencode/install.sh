#
# OpenCode

echo ""
printf "\r  [ \033[00;34m..\033[0m ] starting opencode installation\n"

brew install anomalyco/tap/opencode

opencode_config_dir="$HOME/.config/opencode"
opencode_skills_src="$HOME/.dotfiles/opencode/skills.symlink"
opencode_skills_dst="$opencode_config_dir/skills"

mkdir -p "$opencode_config_dir"

if [ ! -e "$opencode_skills_dst" ] && [ ! -L "$opencode_skills_dst" ] && [ -d "$opencode_skills_src" ]; then
  ln -s "$opencode_skills_src" "$opencode_skills_dst"
fi

exit 0
