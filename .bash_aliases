#! /bin/bash

# =========
#  Git
# =========
gcm() {
    git commit -m "$1"
}
alias ga='git add'
alias gcm=gcm
alias gco='git checkout'
alias ggp='git push origin'
alias ggpull='git pull origin'
alias ggm='git merge $HEAD'
alias gss='git status'

# =========
#  Generic
# =========
mkcd() {
    mkdir "$1" && cd "$1" || exit
}
alias mkcd=mkcd
alias shrel='exec $SHELL'
