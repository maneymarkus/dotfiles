# dotfiles

This is my dotfiles repository, to setup my unix based systems on an automated basis. This repository supports both, MacOS and Linux distributions and checks automatically which OS it is running on.
The shell scripts are written in POSIX compatible code to guarantee their execution on almost every system. Also, they are just for setting up the system and installing my desired shell - which is zsh.

## Install

1. Download `install.sh` from this dotfiles repo:
```
curl -LO https://raw.githubusercontent.com/maneymarkus/dotfiles/main/install.sh
```
2. Make file executable:
```
chmod u+x install.sh
```
3. Run it as root:
```
sudo ./install.sh
```
4. Type in your password
5. Decide what you want to install
6. If you want to create an SSH key you can run the `ssh.sh` file (or run it multiple times for multiple keys) 

## Sources

### dotfiles

- [YouTube: Solving the dotfiles problem](https://www.youtube.com/watch?v=mSXOYhfDFYo)
- [GitHub: Awsome dotfiles](https://github.com/webpro/awesome-dotfiles)

### .gitignore

- [.gitignore templates](https://github.com/github/gitignore)
