#!/bin/bash

echo "LS_COLORS+=':ow=01;33'"  >> ~/.bashrc
echo 'alias ta="tmux attach"' >> ~/.bash_aliases
source ~/.bashrc
sudo apt install build-essential curl git nodejs npm stow -y
sudo snap install --classic nvim

sudo echo "if [ -x /usr/libexec/path_helper ]; then
        PATH="" # <- ADD THIS LINE (right before path_helper call)
        eval `/usr/libexec/path_helper -s`
fi" >> /etc/profile
sudo echo "if [ -x /usr/libexec/path_helper ]; then
        PATH="" # <- ADD THIS LINE (right before path_helper call)
        eval `/usr/libexec/path_helper -s`
fi" >> /etc/zprofile

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim

stow --no-folding -vt ~ .

# Extra supporting packages
sudo apt install luarocks fd-find ripgrep -y
sudo luarocks install jsregexp
sudo npm install -g tree-sitter-cli
sudo apt install -y python3-venv

