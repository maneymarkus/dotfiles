#!/bin/sh

# install xcode command line tools
if [ "$(xcode-select -p 1>/dev/null;echo $?)" -ne 0 ]; then
    echo "Xcode command line tools are not installed. Installing..."
    xcode-select --install

    read -p "Did you install Xcode command line tools? (Y/n):" resp
    # empty response is no
    if [ -z "$resp" ]; then
        resp="n"
    fi
    # case insensitive
    resp=$(echo "$resp" | tr '[:upper:]' '[:lower:]')
    if test "$resp" = "n"; then
        echo "Please install Xcode command line tools before proceeding."
        exit 1
    fi

    if [ "$(xcode-select -p 1>/dev/null;echo $?)" -ne 0 ]; then
        echo "Xcode command line tools are not installed. Abort."
        exit 1
    fi

    echo "Installed Xcode command line tools."
fi

# check if brew is installed
if ! [ -x "$(command -v brew)" ]; then
    echo "Brew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # This line doesn't actually work and won't make brew available in the current shell but you can run it manually. It doesn't matter as the script will restart the shell anyway.
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Installed Brew."
fi

brew update

echo "brew is up-to-date."

# upgrade git
brew install git

echo "Installed git."

# install programs from Brewfile
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# install terraform and mitigate permission issues
sudo tfswitch

echo "Installed programs from Brewfile."
