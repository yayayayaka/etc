#!/bin/sh
set -e

git clone --depth=1 "https://github.com/amix/vimrc.git" ~/.vim_runtime

ln -sfn "$ETC_DIR/vim/my_configs.vim" ~/.vim_runtime/

sh ~/.vim_runtime/install_awesome_vimrc.sh
