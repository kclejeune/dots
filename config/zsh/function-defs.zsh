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
