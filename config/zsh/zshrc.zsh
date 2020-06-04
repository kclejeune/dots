OS=$(uname -s)

###########################################################
# Exports
##########################################################

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export GPG_TTY=/dev/ttys000
export VISUAL=nvim
export EDITOR=nvim
export DEFAULT_USER="$(whoami)"
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export ASDF_CONFIG_DIR=$XDG_CONFIG_HOME/asdf
export ASDF_DATA_DIR=$XDG_DATA_HOME/asdf
export ASDF_CONFIG_FILE=$ASDF_CONFIG_DIR/asdfrc
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=$ASDF_CONFIG_DIR/tool-versions
export KAGGLE_CONFIG_DIR=$XDG_CONFIG_HOME/kaggle
export BAT_CONFIG_PATH="$HOME/.config/bat/bat.conf"

###########################################################
# ALIASES
###########################################################

# update dotfile symlinks from version control
alias dotlink="$HOME/system/install"

# macOS Specific Aliases
if [[ $OS == "Darwin" ]]; then
    alias brewup="brew upgrade && brew cask upgrade && brew cleanup"
fi

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
# Load the theme.
zplug "themes/agnoster", from:oh-my-zsh, defer:3

if [[ $OS == "Darwin" ]]; then
    zplug "plugins/brew", from:oh-my-zsh
    zplug "plugins/osx", from:oh-my-zsh
elif [[ $OS == "Linux" ]]; then
fi

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

###########################################################
# SHELL COMPLETIONS
###########################################################

# Homebrew Completions if on macOS
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# load ASDF into shell
source $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# Completion for kitty
type kitty > /dev/null && kitty + complete setup zsh | source /dev/stdin

# load direnv completions
type direnv > /dev/null && eval "$(direnv hook zsh)"

# completion for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

###########################################################
# FUNCTION DEFINITIONS
###########################################################

function mkvenv() {
    if [[ -z "$1" ]]; then
        DIR="venv"
    else
        DIR=$1
    fi

    if [[ -d $DIR ]]; then
        echo "Remove existing virtual environment? (y/n)"
        read removeExisting
        if [[ $removeExisting == "y" || $removeExisting == "Y" ]]; then
            rm -rf $DIR
        else
            return 0
        fi
    fi

    # make a new virtual environment with the desired directory name
    if type virtualenv > /dev/null; then
        virtualenv ./$DIR
    else
        python3 -m venv ./$DIR
    fi

    # create .envrc if it isn't already there
    touch .envrc
    cat .envrc | grep "source $DIR/bin/activate" > /dev/null || echo "source $DIR/bin/activate" >> .envrc
    cat .envrc | grep "unset PS1" > /dev/null || echo "unset PS1" >> .envrc

    touch .gitignore
    cat .gitignore | grep .env
    cat .gitignore | grep .envrc > /dev/null ||echo .envrc >>.gitignore
    cat .gitignore | grep $DIR > /dev/null ||echo "$DIR/" >>.gitignore

    type direnv > /dev/null && direnv allow
}

function weather() {
    curl wttr.in/$1
}

function config() {
    # navigate to the config file for a specific app
    cd "$XDG_CONFIG_HOME/$1"
}

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
