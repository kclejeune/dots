OS=$(uname -s)

##############################################################
# PLUGINS
##############################################################

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
fi

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "zplug/zplug"
zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/command-not-foudn", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3

if [[ $OS == "Darwin" ]]; then
    zplug "plugins/brew", from:oh-my-zsh
    zplug "plugins/osx", from:oh-my-zsh
elif [[ $OS == "Linux" ]]; then
    if [[ ! -d $HOME/.fnm ]]; then
        curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash
    fi
    export PATH=$HOME/.fnm:$PATH
fi

# Load the theme.
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

# load fnm completions
[[ -d $HOME/.fnm ]] && eval "$(fnm env --multi)"

# load plugin completions
command -v direnv > /dev/null && eval "$(direnv hook zsh)"

###########################################################
# SHELL COMPLETIONS
###########################################################

# Homebrew Completions
if [[ $OS == "Darwin" ]]; then
    if type brew &>/dev/null; then
      FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    fi
fi

# Completion for kitty
command -v kitty > /dev/null && kitty + complete setup zsh | source /dev/stdin

# completion for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

###########################################################
# FUNCTION DEFINITIONS
###########################################################
function mkvenv() {
    if [[ -z "$1" ]]; then
        DIR="venv"
    else
        DIR=$1
    fi

    virtualenv ./$DIR
    echo "source $DIR/bin/activate\nunset PS1" | tee -a .envrc && direnv allow
    echo .envrc >>.gitignore
    echo venv/ >>.gitignore
}

function config() {
    # navigate to the config file for a specific app
    cd "$HOME/.config/$1"
}

###########################################################
# ALIASES
###########################################################
# always prefer neovim
alias vim="nvim"
# stupid cute weather thing
alias weather="curl wttr.in"
# update dotfile symlinks from version control
alias dotlink="$HOME/system/install"
# alias git to use hub wrapper
eval "$(hub alias -s)"

# macOS Specific Aliases
if [[ $OS == "Darwin" ]]; then
    alias brewup="brew upgrade && brew cask upgrade && brew cleanup"
fi

###########################################################
# Exports
##########################################################
# You may need to manually set your language environment
export LANG=en_US.UTF-8

# macOS specific variables
if [[ $OS == "Darwin" ]]; then
    # map python and pip to python3 and pip3 respectively
    export PATH=/usr/local/opt/python/libexec/bin:$PATH
fi

# variable exports
export GPG_TTY=/dev/ttys000
export VISUAL=nvim
export EDITOR=nvim
export DEFAULT_USER="$(whoami)"
export BAT_CONFIG_PATH="$HOME/.config/bat/bat.conf"
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

