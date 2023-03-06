#! /bin/bash

personal_dir=~/Projects/Personal
work_dir=~/Projects/Flair
gh_dir=~/.config/gh

for dir in $personal_dir $work_dir
do
    # [ -f $gh_dir ] && cp -r $gh_dir $dir/.config/gh
    cp .gitconfig $dir
    echo "export GH_CONFIG_DIR=$dir/config/gh" >> $dir/.envrc
    echo "export GIT_CONFIG_GLOBAL=$dir/.gitconfig" >> $dir/.envrc
    direnv allow $dir
done