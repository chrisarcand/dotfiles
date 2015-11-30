# I use vim from Homebrew in OSX; which will get appended to the front of $PATH
# For Fedora/RHEL/CentOS, I use gvim through vim-X11.
if [[ ("$OSTYPE" == "linux-gnu") && (-f "/etc/fedora-release" || -f "/etc/redhat-release") ]]; then
  alias vim='gvim -v'
fi
