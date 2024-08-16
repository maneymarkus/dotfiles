#!/bin/sh

# install xcode command line tools
xcode-select --install

# check if brew is installed
if ! [ -x "$(command -v brew)" ]; then
    echo "Brew is not installed. Installing..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    echo "Installed Brew. Adding to path..."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Added Brew to path. Finished setting up Brew."
fi

brew update

# upgrade git
brew upgrade git

# install programs from Brewfile
brew tap homebrew/bundle
brew bundle --file ./Brewfile

source ./.macos
