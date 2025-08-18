#!/bin/bash

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

ln -s $HOME/.config/nvim/tmux.conf $HOME/tmux.conf
ln -s $HOME/.config/nvim/wezterm $HOME/.config/wezterm
ln -s $HOME/.config/nvim/zellij $HOME/.config/zellij




