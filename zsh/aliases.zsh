if command -v hub >/dev/null 2>&1; then
  alias g='hub'                                                       \
        git='hub'
else
  alias g='git'
fi

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Ye Olde Standards
alias psg='ps aux | grep'                                           \
      grep='ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'                                                  \
      be='bundle exec'                                              \
      bi='bundle install'                                           \
      bif='rm Gemfile.lock && bundle install'                       \
      :q='exit'                                                     \
      nrw='npm run-script watch'                                    \
      reload='source ~/.zshrc'                                      \
      cdir='echo -n $(pwd) | pbcopy'                                \
      path="echo $PATH | tr -s ':' '\n'"                            \
      tdbm='RAILS_ENV=test rake db:migrate'                         \
      rwr='rbenv version'                                           \
      rr='rbenv rehash'                                             \
      dbundle="ruby -I $HOME/workspace/bundler/lib $HOME/workspace/bundler/exe/bundle" \
      dgem="ruby -I $HOME/workspace/rubygems/lib $HOME/workspace/rubygems/bin/gem" \
      weather="curl http://wttr.in" \
      tf="terraform" \
      curseyoudocker="osascript -e 'quit app \"Docker\"' && open -a Docker"

# Common git aliases that I don't type <space> fast enough for
alias ga='g a'                                                      \
      gcm='g cm'                                                    \
      gs='g s'                                                      \
      gdf='g df'

# Novelties
alias wow='git status'                                              \
      such='git'                                                    \
      very='git'
