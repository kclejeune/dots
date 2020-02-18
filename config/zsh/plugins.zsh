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
zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh

zplug "themes/agnoster", from:oh-my-zsh, defer:3
zplug "zsh-users/zsh-autosuggestions", defer:3
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3

if [[ $(uname -s) == 'Darwin' ]]; then
    zplug "plugins/brew", from:oh-my-zsh
    zplug "plugins/osx", from:oh-my-zsh
    # Homebrew Completions
    if type brew &>/dev/null; then
        fpath=$(brew --prefix)/share/zsh/site-functions:$fpath
    fi
elif [[ $(uname -s) == 'Linux' ]]; then
    # do linux specific config
    if [[ ! -d ~/.fnm ]]; then
        # install fnm for node version management if it's not already
        curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash
    fi
fi

zplug load

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi


# load plugin completions
eval "$(direnv hook zsh)"
# fnm
export PATH=/home/kclejeune/.fnm:$PATH
eval "`fnm env --multi`"
