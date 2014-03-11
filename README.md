ChrisArcand's dotfiles
---
Dotfiles, yo.

##Installation
I would bet against myself that these instructions are complete. Just sayin'.

* Install zsh
* Set zsh as your default shell: `chsh -s /bin/zsh`
* Clone repo to .dotfiles in your home directory: `git clone git@github.com:ChrisArcand/dotfiles.git ~/.dotfiles`\*
* Install maximum-awesome: `cd ~/.dotfiles/maximum-awesome && rake`
* Run 'bootstrap.sh' to set up .gitconfig and symlink all the custom dotfiles: `bash ~/.dotfiles/script/bootstrap.sh`\**
* In iTerm2, under 'colors' in your Profile, import the base16-default.dark.256.itermscolors file and use it
* I prefer the colors with a bit more contrast (darker darks, more vibrant color) but I'm too lazy to change the actual colors, so tweak as desired in iTerm

\* Alternatively, you can put them where ever you like, but keep in mind that you'll have to go fix a few things 
(example: the path to oh-my-zsh: `ZSH=$HOME/.dotfiles/oh-my-zsh`)

\** Please take proper precautions and back up your existing setup first. To be blunt, I don't care about your files
and as such, wrote nothing to back your stuff up.
