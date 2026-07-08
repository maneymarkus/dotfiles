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

# install terragrunt autocomplete (will be added to ~/.zshrc but it's fine) if terragrunt is available
if [ -x "$(command -v terragrunt)" ]; then
    terragrunt --install-autocomplete
    echo "Installed terragrunt autocomplete."
fi

DOTFILES_DIR="$HOME/dotfiles"

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

# source shell files
# add source commands to ~/.zprofile.local (gitignored) to avoid polluting the repo
for file in "$DOTFILES_DIR/shell/"*; do
    line="source \"\$DOTFILES_DIR/shell/$(basename "$file")\""
    if ask "Do you want to source $(basename "$file")?"; then
        if ! grep -qF "$line" "$HOME/.zprofile.local" 2>/dev/null; then
            echo "$line" >> "$HOME/.zprofile.local"
        else
            echo "Already sourced: $(basename "$file")"
        fi
    fi
done;
unset file;

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

# restart shell
source .zshrc

# if on MacOS restore defaults
if [ "$(uname -s)" = "Darwin" ]; then
    echo "Restoring defaults..."

    source $HOME/dotfiles/.macos
fi

# if on Linux, give some hints
if [ "$(uname -s)" = "Linux" ]; then
    echo "Now to enable some of the changes (like changing the default user shell to zsh) please log out and in again"
fi
