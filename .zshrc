DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source $ZSH/oh-my-zsh.sh

# zplug
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
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

source "$DOTFILES_DIR/shell/alias.sh"
source "$DOTFILES_DIR/shell/env.sh"

export SHELLUSERNAME=mstaedler

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/markus.staedler/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# krew path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
