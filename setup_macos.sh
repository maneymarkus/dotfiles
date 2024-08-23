#!/bin/sh

# install xcode command line tools
if [ xcode-select -p 1>/dev/null;echo $? -ne 0 ]; then
    echo "Xcode command line tools are not installed. Installing..."
    xcode-select --install
    echo "Installed Xcode command line tools."
fi

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

echo "brew is up-to-date."

# upgrade git
brew upgrade git

echo "Upgraded git."

# install programs from Brewfile
brew tap homebrew/bundle
brew bundle --file ./Brewfile

echo "Installed programs from Brewfile."

echo "Restoring defaults..."

source ./.macos
