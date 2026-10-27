# dotfiles

This is my dotfiles repository, to setup my unix based systems on an automated basis. This repository supports both, MacOS and Linux distributions and checks automatically which OS it is running on.
The shell scripts are written in POSIX compatible code to guarantee their execution on almost every system. Also, they are just for setting up the system and installing my desired shell - which is zsh.\
Update: the `setup_linux.sh` script is now only bash compatible. Should be good enough.

> **Note** (maybe even a warning): These are ***my*** preferences. Handle with care and use at your own risk. No warranty.\
*Batteries included*.


## Structure

- `dotfiles/`: contains actual configuration dotfiles like .gitconfig. Files in this repository will be installed by creating a symlink in the ~ directory linking to the respective file in this directory
- `shell/`: contains shell files that are installed by sourcing them 


## Install

### Without Git

1. You can download the contents of the GitHub repository without using Git but curl or wget as this repository takes care of installing Git:

    ```bash
    mkdir $HOME/dotfiles
    ```

    ```bash
    curl -#L https://github.com/maneymarkus/dotfiles/tarball/main | tar -xzv -C $HOME/dotfiles --strip-components=1
    ```

    or

    ```bash
    wget --no-check-certificate -O - https://github.com/maneymarkus/dotfiles/tarball/main | tar -xzv -C $HOME/dotfiles --strip-components=1
    ```

2. `cd` into the dotfiles directory and make `install.sh` executable:

    ```bash
    cd $HOME/dotfiles && chmod u+x install.sh
    ```

3. Run it:

    ```bash
    ./install.sh
    ```

4. Decide what you want to install


#### Optional: initializing Git and reconnecting the directory to the GitHub repository

The tarball contains no Git history, so the directory is not a Git repository yet and not connected to the GitHub repository. In order to persist changes to these files, `install.sh` reminds you of the following steps at the end:

5. Set up an SSH key that has access to GitHub, either by
    - creating a new one with `./ssh.sh <email> [key_name]` and adding the public key to your GitHub account (the script prints how to copy it), or
    - copying an existing key into `~/.ssh/` (and making sure it is added to GitHub)

6. Run:

    ```bash
    ./init-git.sh
    ```

    This initializes a Git repository in the dotfiles directory, adds the GitHub repository as `origin`, fetches `main` and points the repository at it without touching your files (so the symlinks created by `install.sh` keep working). If the fetch fails (e.g. SSH key not ready) it rolls back and can simply be run again. Optionally pass a different remote URL as argument, e.g. an HTTPS one.

7. You're all set. Check with `git status` and commit changes to the repository.

### With Git

1. Install Git ([MacOS](https://git-scm.com/download/mac) or [Linux](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)).
2. Clone the repository via:

    ```bash
    git clone https://github.com/maneymarkus/dotfiles.git $HOME/dotfiles
    ```

3. Inside the git repo make the install.sh file executable:

    ```bash
    cd $HOME/dotfiles && chmod u+x install.sh
    ```

4. Run it:

    ```bash
    ./install.sh
    ```

5. Type in your password.
6. Decide what you want to install.
7. If you want to create an SSH key you can run the `ssh.sh` file (or run it multiple times for multiple keys). Or reuse an existing key by copying it into the `~/.ssh` directory.
8. If you want to beautify your iterm2 installation, follow [this guide on Medium](https://formulae.brew.sh/formula/zplug).


## Sources

### dotfiles

- [YouTube: Solving the dotfiles problem](https://www.youtube.com/watch?v=mSXOYhfDFYo)
- [GitHub: Awsome dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GitHub: bartekspitza dotfiles](https://github.com/bartekspitza/dotfiles)
- [GitHub: driesvints dotfiles](https://github.com/driesvints/dotfiles)
- [GitHub: webpro dotfiles](https://github.com/webpro/dotfiles)
- [GitHub: holman dotfiles](https://github.com/holman/dotfiles)
- [GitHub: mathiasbynens dotfiles](https://github.com/mathiasbynens/dotfiles)


### .gitignore

- [.gitignore templates](https://github.com/github/gitignore)


## Future developments

For the future this could possibly be enhanced by using Ansible and/or a dotfiles manager like [chezmoi](https://www.chezmoi.io/)
