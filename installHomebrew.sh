#! /bin/bash

# install xcode command line tools
sudo xcode-select --install

# ensure homebrew installation
if [ ! -e /usr/local/bin/brew ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


