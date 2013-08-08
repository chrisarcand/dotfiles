ChrisArcand's dotfiles
---
Dotfiles, yo.

###Configuration
Although it may be convenient to write a shell script to do this, I prefer to oversee recursive deletes and symlinking
directories when configuring my machine - not that it has to be done all that often anyway. Therefore, setup instructions
for each set of settings are given below. 

First, clone to .dotfiles  
<code>git clone https://github.com/ChrisArcand/dotfiles.git ~/.dotfiles</code>

####Sublime Text 2 (/sublime)
Settings are kept in <code>~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User</code>. Delete the User 
directory and create a symlink to /sublime/User

<code>cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages</code>  
<code>rm -rf User</code>  
<code>ln -s ~/.dotfiles/sublime/User/ User</code>

####Bash profile
<code>cd ~</code>  
<code>rm .bash_profile</code>  
<code>ln -s .dotfiles/bash_profile .bash_profile</code>

####Global Git configuration
<code>cd ~</code>  
<code>rm .gitignore</code>  
<code>ln -s .dotfiles/gitignore .gitignore</code>
