DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# zplug
if [ "$(uname -s)" = "Darwin" ]; then
    export ZPLUG_HOME=$(brew --prefix)/opt/zplug
else
    export ZPLUG_HOME="$HOME/.zplug"
fi
source $ZPLUG_HOME/init.zsh

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2

zplug load

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# ZLE key bindings
# opt+backspace: delete back to previous word boundary including special chars (e.g. hyphens)
export WORDCHARS=''
# up/down arrow: search history by the prefix already typed
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

source "$DOTFILES_DIR/shell/alias.sh"
source "$DOTFILES_DIR/shell/env.sh"

export SHELLUSERNAME=mstaedler

# krew path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
