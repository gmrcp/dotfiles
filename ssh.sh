#! /bin/bash

# =============
# Generate SSH and associate to gh account
# =============

cd || exit
read -p 'SSH account name: ' account
ssh-keygen -t ed25519 -C $account

eval "$(ssh-agent -s)"
read -p 'SSH filename: ' filename
ssh-add ~/.ssh/$filename

gh auth login