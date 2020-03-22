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
type direnv &> /dev/null && eval "$(direnv hook zsh)"

###########################################################
# SHELL COMPLETIONS
###########################################################

# Homebrew Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Completion for kitty
type kitty > /dev/null && kitty + complete setup zsh | source /dev/stdin

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

function wcaUpdate() {
    # always remove lingering zip archives before we proceed
    if [[ -e wcaExport.sql.zip ]]; then
        rm wcaExport.sql.zip
    fi

    # remove and redownload the file if the current export is more than 1 day old
    if [[ $(find "WCA_export.sql" -mtime +1 -print) ]]; then
        rm WCA_Export.sql
        echo "Downloading Current WCA Export"
        curl -# -o wcaExport.sql.zip https://www.worldcubeassociation.org/results/misc/WCA_export.sql.zip
        # extract the sql dump
        unzip wcaExport.sql.zip WCA_export.sql && rm wcaExport.sql.zip
    fi

    # specify a .sqlPass with root user password and nothing else, otherwise prompt for the password
    if [[ -e .sqlPass ]]; then
        pass=$(cat .sqlPass)
    else
        read -s -p "MySQL Password: " pass
    fi

    echo "Importing Database"
    # import sql dump
    mysql -u root --password=$pass wca < WCA_export.sql

    echo "Database import complete. Removing archived export files."

    # clean up files, leave sql dump file until the next update
    rm wcaExport.sql.zip
    clear
    echo Updated $(date) >> .updateLog
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
type hub &> /dev/null && eval "$(hub alias -s)"

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
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
