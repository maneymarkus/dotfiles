# add `~/bin` to $PATH
export PATH="$HOME/bin:$PATH"

# add mysql (v8.4) to path
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"

# brew
if [ "$(uname -s)" = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export DOTFILES_DIR="$HOME/dotfiles"

# Machine-specific overrides (gitignored, appended by install.sh)
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
