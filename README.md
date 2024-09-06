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

1. Theoretically, you could download the contents of the GitHub repository without using Git but curl or wget:
```
mkdir $HOME/dotfiles
```
```
curl -#L https://github.com/maneymarkus/dotfiles/tarball/main | tar -xzv -C $HOME/dotfiles --strip-components=1
```
or
```
wget --no-check-certificate -O - https://github.com/maneymarkus/dotfiles/tarball/main | tar -xzv -C $HOME/dotfiles --strip-components=1
```
2. `cd` into the dotfiles directory and make `install.sh` executable:
```
cd $HOME/dotfiles && chmod u+x install.sh
```
3. Run it:
```
./install.sh
```
4. Decide what you want to install
5. If you want to create an SSH key you can run the `ssh.sh` file (or run it multiple times for multiple keys)

#### Optional: "reconnecting" to GitHub repository so that you can update the dotfiles also on this machine

6. Remove the local `dotfiles` repository
```
rm -rf $HOME/dotfiles
```
7. Clone the GitHub repository
```
git clone https://github.com/maneymarkus/dotfiles.git $HOME/dotfiles
# or do it via an SSH key:
git clone git@github.com:maneymarkus/dotfiles.git $HOME/dotfiles
```
8. You're all set. Now you can commit changes to the repository.

> Note: The `install.sh` script creates symlinks to the configuration files in the dotfiles repository rather than copying them into the `$HOME` directory. When you remove the directory the symlinks will be broken, but will work again after cloning the repository into the same directory again. Same with adding `source` commands to the `.zprofile` file. 

### With Git

1. Install Git ([MacOS](https://git-scm.com/download/mac) or [Linux](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))
2. Clone the repository via:
```
git clone https://github.com/maneymarkus/dotfiles.git $HOME/dotfiles
```
3. Inside the git repo make the install.sh file executable:
```
cd $HOME/dotfiles && chmod u+x install.sh
```
4. Run it:
```
./install.sh
```
5. Type in your password
6. Decide what you want to install
7. If you want to create an SSH key you can run the `ssh.sh` file (or run it multiple times for multiple keys)

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
