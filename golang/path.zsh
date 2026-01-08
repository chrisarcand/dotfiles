# export GOENV_ROOT="$HOME/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH" # Path to goenv executable
# export PATH="$HOME/go/bin:$PATH" # All binaries (regardless of version) built with 'go install' are sent to this dir, with GOBIN not set (default). Very intentional.
# export GOENV_DISABLE_GOPATH=1 # DO NOT manage $GOPATH. If you need GOPATH at this point you're doing something wrong and should be using Go 1.11+ modules + /vendor
# Prepend goenv shims to PATH so they take priority over system/Homebrew bins
export PATH="$HOME/.goenv/shims:$PATH"
eval "$(goenv init -)"
