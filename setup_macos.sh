#!/bin/sh

# install xcode command line tools
if [ "$(xcode-select -p 1>/dev/null;echo $?)" -ne 0 ]; then
    echo "Xcode command line tools are not installed. Installing..."
    xcode-select --install
    echo "Installed Xcode command line tools."
fi

# check if brew is installed
if ! [ -x "$(command -v brew)" ]; then
    echo "Brew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Adds brew to the $PATH on macOS machines
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/dotfiles/.zprofile
    # This line doesn't actually work and won't make brew available in the current shell but you can run it manually. It doesn't matter as the script will restart the shell anyway.
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Installed Brew."
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
