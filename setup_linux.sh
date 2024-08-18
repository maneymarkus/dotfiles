#!/bin/bash

pkg_manager="null"

declare -A osInfo;
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp

for f in ${!osInfo[@]}
do
    if [ -f $f ];then
        pkg_manager=${osInfo[$f]}
        # break out of loop at first success
        break
    fi
done

if [ "$pkg_manager" = "null" ]; then
    echo "Unknown package manager. Abort."
    exit 1
fi

# install git
sudo "$pkg_manager" install git-all

# install packages
sudo "$pkg_manager" install python3
sudo "$pkg_manager" install tmux
sudo "$pkg_manager" install gnupg
sudo "$pkg_manager" install awscli
sudo "$pkg_manager" install coreutils
sudo "$pkg_manager" install docker
sudo "$pkg_manager" install zsh
sudo "$pkg_manager" install git-lfs
sudo "$pkg_manager" install jq

if [ "$pkg_manager" != "pacman" ]; then
    sudo "$pkg_manager" install pacman
fi
sudo pacman -S k9s

# install vscode; only works with apt - for other distros see link:
# https://code.visualstudio.com/docs/setup/linux
if [ "$pkg_manager" = "apt" ]; then
    sudo "" install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code
fi

# install composer
sudo "$pkg_manager" install php php-curl
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# install npm via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node # install latest version of node

# install tfswitch as terraform version manager
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | sudo bash

# install latest version of terraform
tfswitch

echo "Please install terragrunt manually via this link: https://terragrunt.gruntwork.io/docs/getting-started/install/"
# Just ask for input to pause script execution
read -p "Did you install terragrunt? (Y/n):" resp

