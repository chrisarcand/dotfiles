# Add current git branch function to prompt
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh

#Change OSX command prompt
#export PS1="\u@\h:\w$ "
export PS1="\w\$(__git_ps1 \" (%s)\")$ "

# Common additions to $PATH
# Pretty print path using " echo $PATH | tr : '\012' "
# /usr/local/bin Homebrew links go here
# /usr/local/share/python Python packages installed with pip
# /usr/local/share/npm/bin This is for npm
# /usr/local/opt/ruby/bin This is for Ruby gem's installed binaries 
# /usr/local/heroku/bin Used by Heroku Toolbelt

export PATH=/usr/local/bin:/usr/local/mysql/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/:$DYLD_LIBRARY_PATH

# Raise resource limit for Node projects
ulimit -n 1024

# Some common aliases
alias g='git' \
      gs='git status' \
      psg='ps aux | grep' \
      be='bundle exec' \
      t='bundle exec rake test'

# Bash completion. 'brew install bash-completion'
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Add completion for g alias for git, too
complete -o default -o nospace -F _git g

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
