# MISC ENVIRONMENT VARIABLES

# Always disable ManageIQ's RequestRefererService
# https://github.com/ManageIQ/manageiq/pull/6502
export MIQ_DISABLE_RRS=1

export SHELL=/bin/zsh

export EDITOR=zed

case $(uname) in
  'Darwin')
    export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/:$DYLD_LIBRARY_PATH
    export PGDATA="/usr/local/var/postgres" # Configuration files for Postgres (-D option)
    export ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future # OSX STUPIDITY
    ;;
esac

# eval "$(tfcdev rc)"
