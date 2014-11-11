#!/bin/bash
#cd ~/dotfiles/
#git@github.com:blutgens/dotfiles.git
mv -i ~/.vim{,_old}
mv -i ~/.ssh{,_old}
mv -i ~/bin{,_old}
ln -sf ~/dotfiles/.??*  .
ln -sf ~/dotfiles/*  .
