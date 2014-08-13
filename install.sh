#!/bin/bash

pushd Sublime\ Text\ 2
cp -r * ~/Library/Application\ Support/Sublime\ Text\ 2
popd

mkdir ~/.vim
pushd vim
cp -r * ~/.vim
popd

cp .vimrc ~/.vimrc
cp .gitconfig ~/.gitconfig
cp .bash_profile ~/.bash_profile
