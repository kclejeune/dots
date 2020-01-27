# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/command-not-foudn", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
# Load the theme.
zplug "zsh-users/zsh-autosuggestions", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3
# ZSH port of Fish shell's history search feature
zplug "zsh-users/zsh-history-substring-search", defer:3

if [[ $(uname -s) == 'Darwin' ]]; then
    zplug "plugins/brew", from:oh-my-zsh
    zplug "plugins/osx", from:oh-my-zsh
fi

zplug "themes/agnoster", from:oh-my-zsh, defer:3

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load
