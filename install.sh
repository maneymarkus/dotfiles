#!/bin/sh
# Run script via sudo

if [ "$(uname -s)" = "Linux" ]; then
    ./setup_linux.sh
elif [ "$(uname -s)" = "Darwin" ]; then
    ./setup_macos.sh
else
    echo "Unsupported OS. Abort"
    exit 1
fi

echo "OS setup complete."

# check if zsh is default shell, if not do so
if [ $(basename $SHELL) != "zsh" ]; then
    echo "zsh is not default shell. Changing..."
    chsh -s $(which zsh)
    echo "Changed default shell for current user to zsh."
fi

echo "zsh is default shell."

# check if oh-my-zsh is available
if ! [ -x "$(command -v omz)" ]; then
    echo "oh-my-zsh is not available. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Installed oh-my-zsh."
fi

echo "oh-my-zsh is available."

# update oh-my-zsh
omz update

echo "oh-my-zsh is up-to-date."

# install dotfiles repo
git clone https://github.com/maneymarkus/dotfiles.git ~/dotfiles

echo "Cloned dotfiles repo."

# removes .zshrc from $HOME and symlinks the .zshrc file from dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc

# install dotfiles

# install programs

source $HOME/.zprofile
