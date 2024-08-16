#!/bin/sh

usage () {
    echo "usage: $0 [OPTIONS] [EMAIL] [KEY_NAME]"
    echo
    echo "OPTIONS:"
    echo "  -h      Display this help"
    echo
    echo "ARGUMENTS:"
    echo "  EMAIL     Enter your email address that should be associated with the generated key"
    echo "  KEY_NAME  The name of the key. Will also be the file name then. When no value is given 'personal_key' is used."
    exit 1
}

# handle flags
while getopts "h:" flag; do
    case $flag in
        h)
        usage
        ;;
        \?)
        usage
        ;;
    esac
done

if [ -z "$1" ]; then
    echo "Please provide your email address."
    usage
fi

# keyname
key_name="personal_key"

if ! [ -z "$2" ]; then
    key_name=$2
fi

echo "Generating a new SSH key..."

# Guide: https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# Generating a new SSH key
ssh-keygen -t ed25519 -C $1 -f ~/.ssh/$key_name

# Adding your SSH key to the ssh-agent
eval "$(ssh-agent -s)"

# If a passphrase has been set for ssh key, on macos the passphrase should be stored in the keychain
apple_use_keychain=""

if [ "$(uname -s)" = "Darwin" ]; then
    # If you're experiencing problems, check this guide: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=mac#adding-your-ssh-key-to-the-ssh-agent
    # (and make sure it shows the guide for Mac)
    touch ~/.ssh/config
    echo "Host *\n  AddKeysToAgent yes\n" | tee ~/.ssh/config

    read -p "Did you set a passphrase for your key? (Y/n):" resp
    if [ -z "$resp" ]; then
        echo "  UseKeychain yes\n" >> ~/.ssh/config
        apple_use_keychain="--apple-use-keychain "
    fi

    echo "  IdentityFile ~/.ssh/$key_name" >> ~/.ssh/config

fi

ssh-add $apple_use_keychain ~/.ssh/$key_name

# Adding your SSH key to your GitHub account
# https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
if [ "$(uname -s)" = "Darwin" ]; then
    echo "run 'pbcopy < ~/.ssh/$key_name.pub' and paste that into GitHub"
fi

if [ "$(uname -s)" = "Linux" ]; then
    echo "run 'cat < ~/.ssh/$key_name.pub', copy the output and paste that into GitHub"
fi