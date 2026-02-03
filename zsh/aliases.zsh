alias g='git'                                                       \
      dc='docker compose'

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

# Wrap claude with Bedrock config when USE_CLAUDE_BEDROCK=1.
# Set USE_CLAUDE_BEDROCK=1 in ~/.private-zshrc on work machines.
claude() {
  if [[ "$USE_CLAUDE_BEDROCK" == "1" ]]; then
    # Specify the model to use for most requests. Default: claude-sonnet-4-5.
    export ANTHROPIC_MODEL="global.anthropic.claude-sonnet-4-5-20250929-v1:0"

    # Specify a faster model to use for quick operations. Default: claude-haiku-4-5.
    export ANTHROPIC_SMALL_FAST_MODEL="global.anthropic.claude-haiku-4-5-20251001-v1:0"

    # AWS region for Bedrock requests.
    export ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION="us-east-1"

    # AWS profile to use for Bedrock authentication.
    export AWS_PROFILE=${AWS_PROFILE:-sandbox_bedrock}

    # Required for AWS SDK to read ~/.aws/config file
    export AWS_SDK_LOAD_CONFIG=1

    # Enable AWS Bedrock as the model provider instead of the Anthropic API.
    export CLAUDE_CODE_USE_BEDROCK=1

    # Disable prompt caching. Set to 1 to disable. Default: 0 (enabled). Prompt caching reduces costs
    # and latency by reusing previously processed prompts.
    export DISABLE_PROMPT_CACHING=0

    # Equivalent of setting DISABLE_AUTOUPDATER, DISABLE_BUG_COMMAND, DISABLE_ERROR_REPORTING, and
    # DISABLE_TELEMETRY
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

    # Set the maximum number of output tokens for most requests. Default: 32,000. Maximum: 64,000.
    # Increasing this value reduces the effective context window available before auto-compaction
    # triggers.
    export CLAUDE_CODE_MAX_OUTPUT_TOKENS=${CLAUDE_CODE_MAX_OUTPUT_TOKENS:-16000}

    # Override the extended thinking token budget. Thinking is enabled at max budget (31,999 tokens) by
    # default. Use this to limit the budget (for example, MAX_THINKING_TOKENS=10000) or disable thinking
    # entirely (MAX_THINKING_TOKENS=0). Extended thinking improves performance on complex reasoning and
    # coding tasks but impacts prompt caching efficiency.
    export MAX_THINKING_TOKENS=${MAX_THINKING_TOKENS:-4000}
  fi

  command claude "${@}"
}
