#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.dotfiles"


# ----- zsh/oh-my-zsh
sudo apt install zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ln -sf ~/.dotfiles/.gitconfig  ~/.gitconfig
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# ----- JetBrains Mono
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"


# ----- NVM/Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node


# ----- VSCODE
sudo snap install --classic code

VSCODE_HOME="$HOME/.config/Code"

ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_HOME/User/settings.json"
ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_HOME/User/keybindings.json"
ln -sf "$DOTFILES/vscode/snippets" "$VSCODE_HOME/User/snippets"

while read -r module; do
	code --install-extension "$module" || true
done <"$DOTFILES/vscode/extensions.txt"


# ----- Docker
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin