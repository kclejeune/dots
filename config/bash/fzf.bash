# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.local/share/asdf/installs/fzf/0.27.2/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/kcl60/.local/share/asdf/installs/fzf/0.27.2/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.local/share/asdf/installs/fzf/0.27.2/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.local/share/asdf/installs/fzf/0.27.2/shell/key-bindings.bash"
