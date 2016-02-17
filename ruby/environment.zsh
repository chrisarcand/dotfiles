# Fixes Pry stupidity with history by using GNU readline instead of libedit
# See https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X
export RUBY_CONFIGURE_OPTS=--with-readline-dir=`brew --prefix readline`

