# aliases
alias vim="nvim"
alias v="nvim"
alias mkvenv="virtualenv ./venv && echo 'source venv/bin/activate\nunset PS1' | tee -a .envrc && direnv allow && echo '.envrc' >> .gitignore"
alias weather="curl wttr.in"
alias brewup="brew upgrade && brew cask upgrade && brew cleanup"
alias dotlink="$HOME/system/install"
alias config="cd $HOME/.config"
