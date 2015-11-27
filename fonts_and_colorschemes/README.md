This directory contains colorschemes to be set up in your terminal emulator.

## Colorscheme - Base16 Dark
### OSX with iTerm2
Go to preferences and use the itermcolors schemes provided. The 256 color one is for the following:

> The 256 variations are provided for those people who use a lot of colored command line programs and wish to keep the default 16 ANSI colors intact. If this means nothing to you please make use of the default 16 color versions (the files without 256 in them). On the other hand if you'd like to keep your 16 ANSI colors intact, go ahead and use the 256 color variations but please note you'll need to modify some of the 256 colorspace with the Base16 Shell script.

For more, see https://github.com/chriskempson/base16-iterm2

### Gnome Terminal
`source <this directory>/base16-default.dark-gnome-installer.sh`

Next, restart or open Gnome Terminal. Right click on the terminal and select profiles the menu that pops-up. The scheme
you just sourced should be available for selection.

For more, see https://github.com/chriskempson/base16-gnome-terminal


### Vim
Terminal vim needs the emulator's colorscheme set (above), then the settings used in my dotfiles will just work.
This includes sourcing the base16-shell script in zshrc. Without sourcing this, you'll see awkward, messed up
colors (bright blue/green) in vim, because it's not using the correct colorspace.

For more, see https://github.com/chriskempson/base16-vim and https://github.com/chriskempson/base16-shell

## Font - Inconsolata (with Powerline)

The otf is found in this directory; your emulator should be easy enough to figure out how to set the font.
