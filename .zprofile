# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# add `~/bin` to $PATH
export PATH="$HOME/bin:$PATH"