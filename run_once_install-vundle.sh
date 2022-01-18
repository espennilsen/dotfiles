#!/usr/bin/env bash
set -e
dir="$HOME/.vim/bundle/Vundle.vim"

if cd $dir; then
  git pull
  # vim +PluginUpdate +qall
else
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +BundleInstall +qall
fi
