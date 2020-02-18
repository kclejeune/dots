# Homebrew Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/function-defs.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/exports.zsh
source $HOME/.config/zsh/completions.zsh

