#! /bin/bash

log_file=./install_progress_log.txt
touch $log_file

RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

rc_file=.bashrc

## printing functions ##
gecho() {
    echo "${Gre}[message] $1${RCol}"
}

yecho() {
    echo "${Yel}[warning] $1${RCol}"
}

wecho() {
    # red, but don't exit 1
    echo "${Red}[error] $1${RCol}"
}

recho() {
    echo "${Red}[error] $1${RCol}"
    exit 1
}

# look for CLI tool, if not install via apt-get
install_apt_get() {
  (command -v "$1" > /dev/null  && gecho "$1 found...") || 
    (yecho "$1 not found, installing via apt-get..." && sudo apt-get install -y "$1")
}

# ---
# Install git-completion and git-prompt
# ---
# cd || exit
# curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
# curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
# echo "git-completion and git-prompt Installed and Configured" >> $log_file

# ---
# Install nvm
# ---
# cd || exit
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# nvm install 'lts/*'
# command -v nvm

# check for pre-req, fail if not found
check_preq() {
    (command -v "$1" >/dev/null && gecho "$1 found...") ||
        recho "$1 not found, install before proceeding."
}

# function for linking dotfiles
link_dotfile() {
    file="$1"
    if [ ! -e ~/"$file" -a ! -L ~/"$file" ]; then
        yecho "$file not found, linking..." >&2
        ln -s "$(pwd)/$file" ~/"$file"
    else
        gecho "$file found, ignoring..." >&2
    fi
}

add_line_to_rc() {
    echo "$1" >> ~/$rc_file
}

link_dotfile .bash_aliases

link_dotfile .bash_profile
add_line_to_rc 'source ~/.bash_profile'

install_apt_get direnv
add_line_to_rc 'eval "$(direnv hook bash)"'


#==============
# direnv for multiple gh accounts
#==============
personal_dir=~/Projects/Personal
work_dir=~/Projects/Flair
gh_dir=~/.config/gh

for dir in $personal_dir $work_dir
do
    [ -f $gh_dir ] && cp -r $gh_dir $dir/.config/gh
    cp .gitconfig $dir
    echo "export GH_CONFIG_DIR=$dir/.config/gh" >> $dir/.envrc
    echo "export GIT_CONFIG_GLOBAL=$dir/.gitconfig" >> $dir/.envrc
    direnv allow $dir
done


#==============
# Give the user a summary of what has been installed
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
rm $log_file

# reload shell 
exec bash