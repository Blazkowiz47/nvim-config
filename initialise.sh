#!/bin/bash

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim

sudo -y apt install stow
stow --no-folding -vt ~ .

# Extra supporting packages
sudo -y apt install luarocks fd-find ripgrep
sudo -y luarocks install jsregexp
sudo npm install -g tree-sitter-cli
