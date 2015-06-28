#!/bin/bash
function _fileExistAndEqualTo
{
	if [ -f $1 ]; then
		diff $1 $2 | wc -l | echo -
	else
		echo "1"
	fi
}
function isBashConfigured
{
	echo $(_fileExistAndEqualTo "~/.bashrc" "./bash/bashrc")
}
function isDunstConfigured
{
	echo $(_fileExistAndEqualTo "~/.config/dunst/dunstrc" "./dunst/dunstrc")
}
function isHLWMConfigured
{
}
function isVimConfigured
{
	echo $(_fileExistAndEqualTo "~/.vimrc" "./vim/vimrc")
}
function isXorgConfigured
{
	#echo $(_fileExistAndEqualTo "~/.xinitrc" "./xorg/xinitrc")
	#echo $(_fileExistAndEqualTo "~/.Xresources" "./xorg/Xresources")
}
