function gi() { curl -sLw "\n" https://www.gitignore.io/api/\$@ ;}

function mkvenv () {
    if [ -z "$1" ]; then
        DIR="venv"
    else
        DIR=$1
    fi

    virtualenv ./$DIR
    echo "source $DIR/bin/activate\nunset PS1" | tee -a .envrc && direnv allow
    echo .envrc >> .gitignore
    echo venv/ >> .gitignore
}
