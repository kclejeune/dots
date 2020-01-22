# You may need to manually set your language environment
export LANG=en_US.UTF-8

source /usr/local/share/antigen/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# other packages
antigen bundle sudo
antigen bundle common-aliases
# OS specific plugins
if [[ $(uname -s) == 'Darwin' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx
elif [[ $(uname -s) == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'CentOS' ]]; then
        antigen bundle centos
    fi
fi

# Load the theme.
antigen theme agnoster

# Tell Antigen that you're done.
antigen apply

autoload -Uz compinit
compinit
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# add direnv hook for .envrc support
eval "$(direnv hook zsh)"
alias weather="curl wttr.in"

# aliases
alias vim="nvim"
alias v="nvim"
export GPG_TTY=/dev/ttys000

# path modifications
export PATH=/usr/local/opt/python/libexec/bin:$PATH
