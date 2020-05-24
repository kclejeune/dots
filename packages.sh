#!/usr/bin/env bash

./installHomebrew.sh

# install Brewfile contents
brew bundle install

# add /usr/local/bin/zsh to acceptable shells and set it as default
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
