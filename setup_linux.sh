#!/usr/bin/env bash

pkg_manager="null"

declare -A osInfo;
osInfo[/etc/debian_version]=apt-get
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
sudo "$pkg_manager" -y install git-all

# install packages
sudo "$pkg_manager" install -y python3 tmux gnupg coreutils zsh git-lfs jq curl just # install curl as a precaution (because might not be installed e.g. on Ubuntu and wget was used to download dotfiles)

# install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
unzip $HOME/awscliv2.zip -d $HOME
sudo $HOME/aws/install

# install k9s from GitHub releases (distro-agnostic)
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -L "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" -o /tmp/k9s.tar.gz
tar -xzf /tmp/k9s.tar.gz -C /tmp k9s
sudo mv /tmp/k9s /usr/local/bin/k9s
rm /tmp/k9s.tar.gz

# install vscode; only works with apt - for other distros see link:
# https://code.visualstudio.com/docs/setup/linux
if [ "$pkg_manager" = "apt-get" ]; then
    sudo apt-get install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    
    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y code
fi

# install docker; might be replaced with Rancher Desktop later
if [ "$pkg_manager" = "apt-get" ]; then
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi


# install composer
sudo "$pkg_manager" -y install php php-curl
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# install node via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node # install latest version of node

# install tfswitch as terraform version manager
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | sudo bash

# install latest version of terraform (if no local installation exists) and mitigate permission issues (with sudo)
if ! [ -x "$(command -v terraform)" ]; then
    mkdir -p $HOME/bin
    tfswitch -b $HOME/bin/terraform
fi

echo "Please install terragrunt manually via this link: https://terragrunt.gruntwork.io/docs/getting-started/install/"
# Just ask for input to pause script execution
read -p "Did you install terragrunt? (Y/n):" resp
