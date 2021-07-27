#! /usr/bin/env awk -f

/.*\s.*/ { 
    system("asdf plugin add " $1); 
    system("asdf install " $1 " " $2) 
    system("asdf global " $1 " " $2) 
}
