# General aliases
alias vim="nvim"
alias v="nvim"
alias weather="curl wttr.in"
alias dotlink="$HOME/system/install"
eval "$(hub alias -s)"

# macOS Specific Aliases
if [[ $(uname -s) == 'Darwin' ]]; then
    alias brewup="brew upgrade && brew cask upgrade && brew cleanup"
fi
