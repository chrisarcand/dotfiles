# Chris Arcand's dotfiles

Your dotfiles are how you personalize your system. These are mine.

This contains my own configurations for git, zed, zsh using oh-my-zsh, ruby, pry, and more.
The provided installer includes support for the following OS/distributions:

- MacOS

...that's it really, I still have some of this lying around but I won't expect it to work:

- Fedora
- Red Hat Enterprise Linux
- CentOS

## Installation

There is an install script to automatically symlink all the configuration files
to your home directory and install packages for supported operating systems.

```plaintext
$ git clone --recursive git@github.com:chrisarcand/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/install.sh
```

Note: Although the install script is quite good and will back up your own
existing dotfiles with nice prompts, I take no responsibility for your system.
Please be sure to back up your files appropriately before installation if
there's anything important that already exists.

You'll need to set up things like your default shell and fonts n' stuff in your terminal emulator yourself, after this installation.

### Organization

These files follow a topic-based organizational scheme originally popularized by Zach Holman.
The organization is as follows:

- **bin/**
  Anything in bin/ will get added to your $PATH and be made available everywhere.

- **\<topic\>/\*.zsh**
  Any files ending in .zsh get loaded into your environment.

- **\<topic\>/path.zsh**
  Any file named path.zsh is loaded first and is expected to
  setup $PATH or similar.

- **\<topic\>/completion.zsh**
  Any file named completion.zsh is loaded last and is
  expected to set up autocomplete.

- **\<topic\>/\*.symlink**
  Any files ending in `.symlink` get symlinked into your $HOME when you use the
  provided install script. This is so you can keep all of those versioned in
  your dotfiles but still keep those autoloaded files in your home directory.

- **\_plugins/**
  This directory houses git submodules to properly version important external dependencies. I don't
  do this for all plugins, but make an exception for some things like oh-my-zsh and tmux plugins.

### Zed

Some time back I switched from vim/nvim to Zed. Many of the basic bindings emulate my old vim+tmux
setup, which originally came from [Maximum Awesome](https://github.com/square/maximum-awesome), the
set of dotfiles I originally started using with vim. `,` is the Vim leader key, and `ctrl-a z` is
the Tmux-style prefix.

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
