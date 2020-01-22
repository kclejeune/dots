#!/bin/bashOAOBOA

# manage .config symlinking from kclejeune/system repository
cd ~/ || exit 1
ln -s ~/system/config/zsh/.zshrc .
mkdir -p ~/.config ~/.config/kitty ~/.config/nvim
cd ~/.config || exit 1
ln -s ~/system/config/kitty/ .
ln -s ~/system/config/nvim/ .

# install xcode command line tools
sudo xcode-select --install

# ensure hoOAOAmebrew installation
if [ ! -e /usr/local/bin/brew ]; then
    /OAusr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install Brewfile contents
brew bundle install > install_log 

# add /usr/local/bin/zsh to acceptable shells and set it as default
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
