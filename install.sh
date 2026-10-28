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

DOTFILES_DIR="$HOME/dotfiles"

if [ "$(uname -s)" = "Linux" ]; then
    bash "$DOTFILES_DIR/setup_linux.sh"
elif [ "$(uname -s)" = "Darwin" ]; then
    bash "$DOTFILES_DIR/setup_macos.sh"
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

# install terragrunt autocomplete (will be added to ~/.zshrc but it's fine) if terragrunt is available
if [ -x "$(command -v terragrunt)" ]; then
    terragrunt --install-autocomplete
    echo "Installed terragrunt autocomplete."
fi

# symlink a file from the dotfiles repo into $HOME, idempotently
symlink () {
    local src="$1" dst="$2"
    if [ "$(readlink "$dst")" = "$src" ]; then
        echo "Already symlinked: $dst"
    else
        # Remove only if it's a regular file or a wrong symlink, never silently delete a directory
        if [ -f "$dst" ] || [ -L "$dst" ]; then
            rm "$dst"
        fi
        ln -s "$src" "$dst"
        echo "Symlinked: $dst -> $src"
    fi
}

symlink "$DOTFILES_DIR/.zshrc"   "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"

# install dotfiles via symbolic link
for file in "$DOTFILES_DIR/dotfiles/".*; do
    if test -f "$file" && ask "Do you want to install $(basename "$file")?"; then
        symlink "$file" "$HOME/$(basename "$file")"
    fi
done;
unset file;

# set up git pre-push hook via symlink into ~/.git-templates/hooks
echo "Setting up git pre-push hook..."
mkdir -p "$HOME/.git-templates/hooks"
chmod +x "$HOME/dotfiles/git/hooks/pre-push"
ln -sf "$HOME/dotfiles/git/hooks/pre-push" "$HOME/.git-templates/hooks/pre-push"
echo "Git pre-push hook installed at ~/.git-templates/hooks/pre-push"

# if on MacOS restore defaults
if [ "$(uname -s)" = "Darwin" ]; then
    echo "Restoring defaults..."

    source $HOME/dotfiles/.macos

    echo "Done. Open a new terminal window to load the new shell configuration."
fi

# if on Linux, give some hints
if [ "$(uname -s)" = "Linux" ]; then
    echo "Now to enable some of the changes (like changing the default user shell to zsh) please log out and in again"
fi

# if this directory is not a git repository yet (installed via tarball), explain how to connect it
if [ ! -e "$DOTFILES_DIR/.git" ]; then
    echo
    echo "This dotfiles directory is not a Git repository yet. To be able to update/commit dotfiles from this machine:"
    echo "  1. Set up an SSH key: either create a new one with './ssh.sh <email> [key_name]' (and add the public key to GitHub),"
    echo "     or copy an existing key into $HOME/.ssh/ (and make sure it is added to GitHub)."
    echo "  2. Then run './init-git.sh' to connect this directory to the GitHub repository."
fi
