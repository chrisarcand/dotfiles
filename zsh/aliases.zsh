# Ye Olde Standards
alias g='hub'                                                       \
      git='hub'                                                     \
      psg='ps aux | grep'                                           \
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
      rr='rbenv rehash'

# Common git aliases that I don't type <space> fast enough for
alias ga='g a'                                                      \
      gcm='g cm'                                                    \
      gs='g s'                                                      \
      gdf='g df'

# Novelties
alias wow='git status'                                              \
      such='git'                                                    \
      very='git'
