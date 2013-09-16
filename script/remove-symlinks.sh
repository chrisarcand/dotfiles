#!/usr/bin/env bash

echo 'Removing symlinks in home directory...'

echo '.gitconfig'
rm ~/.gitconfig

echo '.gitignore'
rm ~/.gitignore

echo '.zshrc'
rm ~/.zshrc

echo 'Done!'