#!/usr/bin/env bash

ask () {
    read -p "$1 (Y/n): " resp

    # empty response is no
    if [ -z "$resp" ]; then
        resp="n"
    fi

    # case insensitive
    resp=$(echo "$resp" | tr '[:upper:]' '[:lower:]')

    test "$resp" = "y"
}

if [ "$(uname -s)" = "Linux" ]; then
    bash setup_linux.sh
elif [ "$(uname -s)" = "Darwin" ]; then
    sh setup_macos.sh
    if [ $? -ne 0 ]; then
        echo "MacOS Setup failed. Abort."
        exit 1
    fi
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Installed oh-my-zsh."
fi

echo "oh-my-zsh is available."

# install terragrunt autocomplete (will be added to ~/.zshrc but it's fine) if terragrunt is available
if ! [ -x "$(command -v terragrunt)" ]; then
    terragrunt --install-autocomplete
    echo "Installed terragrunt autocomplete."
fi

# removes .zshrc from $HOME and symlinks the .zshrc file from dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc

# removes .zprofile from $HOME and symlinks the .zprofile file from dotfiles
rm -rf $HOME/.zprofile
ln -s $HOME/dotfiles/.zprofile $HOME/.zprofile

# source shell files
# add source command to ~/.zprofile
for file in $HOME/dotfiles/shell/*; do
    if ask "Do you want to source $(basename "$file")?"; then
        echo "source $(realpath "$file")" >> $HOME/.zprofile
    fi
done;
unset file;

# install dotfiles via symbolic link
for file in $HOME/dotfiles/dotfiles/.*; do
    if test -f "$file" && ask "Do you want to install $(basename "$file")?"; then
        ln -s $file "$HOME/$(basename "$file")";
    fi
done;
unset file;

# restart shell
source .zshrc
# .zprofile doesn't have to be sourced here again as .zshrc already contains this line

# if on MacOS restore defaults
if [ "$(uname -s)" = "Darwin" ]; then
    echo "Restoring defaults..."

    source $HOME/dotfiles/.macos
fi

# if on Linux, give some hints
if [ "$(uname -s)" = "Linux" ]; then
    echo "Now to enable some of the changes (like changing the default user shell to zsh) please log out and in again"
fi
