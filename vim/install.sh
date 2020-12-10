#!/bin/sh
set -e

git clone --depth=1 git://github.com/amix/vimrc.git ~/.vim_runtime

ln -sfn $XDG_CONFIG_HOME/vim/my_configs.vim ~/.vim_runtime/

cd ~/.vim_runtime
echo 'set runtimepath+=~/.vim_runtime

. ~/.vim_runtime/vimrcs/basic.vim
. ~/.vim_runtime/vimrcs/filetypes.vim
. ~/.vim_runtime/vimrcs/plugins_config.vim
. ~/.vim_runtime/vimrcs/extended.vim

try
. ~/.vim_runtime/my_configs.vim
catch
endtry' > ~/.vimrc
