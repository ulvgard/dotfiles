#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

function printGreen {
	printf "${GREEN}$1${NC}"
}
function printRed {
	printf "${RED}$1${NC}"
}
function printConfigured {
	printGreen "[configured]"
	}
function printNotConfigured {
	printRed "[not configured]"
}


function _fileExistAndEqualTo
{
	if [ -f $1 ]; then
		if [ $(diff $1 $2 | wc -l) -gt 0 ] ; then
			echo 1;
		else
			echo 0;
		fi
	else
		echo 1;
	fi
}
function isBashConfigured
{
	if [[ $(_fileExistAndEqualTo ~/.bashrc ./bash/bashrc) -eq 0 ]]; then
		printConfigured
	else
		printNotConfigured	
		echo "\n  -> ~/.bashrc"
	fi
}
function isDunstConfigured
{
	if [[ $(_fileExistAndEqualTo ~/.config/dunst/dunstrc ./dunst/dunstrc) -eq 0 ]]; then
		printConfigured
	else
		printNotConfigured	
		echo "\n  -> ~/.config/dunst/dunstrc"
	fi
}
function isHLWMConfigured
{
	if [[ $(_fileExistAndEqualTo ~/.config/herbstluftwm/autostart ./wm/herbstluftwm/autostart) -eq 0 ]] && \
	   [[ $(_fileExistAndEqualTo ~/.config/herbstluftwm/panel.sh ./wm/herbstluftwm/panel.sh) -eq 0 ]]; then
		printConfigured
	else
		printNotConfigured	
		echo "\n  -> ~/.config/herbstluftwm/autostart"
		echo "\n  -> ~/.config/herbstluftwm/panel.sh"
	fi
}
function isVimConfigured
{
	if [[ $(_fileExistAndEqualTo ~/.vimrc ./vim/vimrc) -eq 0 ]]; then
		printConfigured
	else
		printNotConfigured	
		echo "\n  -> ~/.vimrc"
	fi
}
function isGitConfigured
{
	if [[ $(_fileExistAndEqualTo ~/.gitconfig ./git/gitconfig) -eq 0 ]]; then
		printConfigured
	else
		printNotConfigured	
		echo "\n  -> ~/.gitconfig"
	fi
}
function isXorgConfigured
{
	if  [[ $(_fileExistAndEqualTo ~/.xinitrc ./xorg/xinitrc) -eq 0 ]] && \
		[[ $(_fileExistAndEqualTo ~/.Xresources ./xorg/Xresources) -eq 0 ]]; then
		printConfigured
	else
		printNotConfigured	
		echo "\n  -> ~/.xinitrc"
		echo "\n  -> ~/.Xresources"
	fi
}

function _checkIfInstalled
{
	pacman -Qi $1 &> /dev/null;
	if [  $? -eq 0 ]; then
		printGreen "[installed]"
	else
		printRed "[not installed]"
	fi
}

function showConfigStatus 
{
	echo -e "bash\t\t"$(_checkIfInstalled bash)"\t"$(isBashConfigured)
	echo -e "dunst\t\t"$(_checkIfInstalled dunst)"\t"$(isDunstConfigured)
	echo -e "herbstluftwm\t"$(_checkIfInstalled herbstluftwm)"\t"$(isHLWMConfigured)
	echo -e "Git\t\t"$(_checkIfInstalled git)"\t"$(isGitConfigured)
	echo -e "Vim\t\t"$(_checkIfInstalled vim-runtime)"\t"$(isVimConfigured)
	echo -e "Xorg\t\t"$(_checkIfInstalled xorg-server)"\t"$(isXorgConfigured)

}

echo "Usage:"
echo "================================="
echo "List installed and configured packages: showConfigStatus"
