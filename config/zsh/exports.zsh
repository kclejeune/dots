# You may need to manually set your language environment
export LANG=en_US.UTF-8

# macOS specific variables
if [[ $(uname -s) == 'Darwin' ]]; then
    export PATH=/usr/local/opt/python/libexec/bin:$PATH
fi

# variable exports
export GPG_TTY=/dev/ttys000
export VISUAL=nvim
export EDITOR=nvim
