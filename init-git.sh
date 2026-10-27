#!/bin/sh

DEFAULT_REMOTE="git@github.mpi-internal.com:markus-staedler/dotfiles.git"
BRANCH="main"

usage () {
    echo "usage: $0 [OPTIONS] [REMOTE_URL]"
    echo
    echo "Turns a dotfiles directory obtained as tarball into a Git repository and connects it to the remote."
    echo "Your files are left untouched; Git just starts tracking them against origin/$BRANCH."
    echo
    echo "OPTIONS:"
    echo "  -h      Display this help"
    echo
    echo "ARGUMENTS:"
    echo "  REMOTE_URL  The remote to connect to. Defaults to $DEFAULT_REMOTE"
    exit 1
}

while getopts "h" flag; do
    case $flag in
        h|\?)
        usage
        ;;
    esac
done
shift $((OPTIND - 1))

remote_url="${1:-$DEFAULT_REMOTE}"

cd "$(dirname "$0")" || exit 1

if ! command -v git >/dev/null 2>&1; then
    echo "Git is not installed. Run ./install.sh first."
    exit 1
fi

if [ -e .git ]; then
    echo "This directory is already a Git repository. Nothing to do."
    exit 0
fi

echo "Initializing Git repository..."
git init -q -b "$BRANCH" || exit 1
git remote add origin "$remote_url" || exit 1

echo "Fetching $remote_url..."
if ! git fetch origin "$BRANCH"; then
    echo
    echo "Fetching failed. Is your SSH key set up and added to GitHub (see ssh.sh)?"
    echo "Rolling back. Fix the problem and run $0 again."
    rm -rf .git
    exit 1
fi

# Mixed reset: moves HEAD and index to origin/main but leaves the working tree untouched
git reset -q "origin/$BRANCH" || exit 1
git branch --set-upstream-to="origin/$BRANCH" "$BRANCH" >/dev/null

echo
echo "Done. Connected to $remote_url."
if [ -n "$(git status --porcelain)" ]; then
    echo "Note: your files differ from origin/$BRANCH (tarball not up to date or local changes):"
    git status --short
else
    echo "Working tree matches origin/$BRANCH."
fi
