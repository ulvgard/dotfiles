#!/bin/bash
PKG_MGR_CMD="sudo pacman -S "

function configure_bash() {
	pacman -Qi bash &> /dev/null
	if [[ ! $? -eq 0 ]]; then
		echo "* Installing bash"
		sudo pacman -Syy bash 
	fi
	echo "* Configuring bashrc"
	cp bash/bashrc $HOME/.bashrc
}
function configure_dunst {
	pacman -Qi dunst &> /dev/null
	if [[ ! $? -eq 0 ]]; then
		echo "* Installing dunst"
		sudo pacman -Syy dunst
	fi
	echo "* Configuring dunst"
	mkdir -p $HOME/.config/dunst/
	cp dunst/dunstrc $HOME/.config/dunst/dunstrc
}
function configure_git() {
	pacman -Qi git &> /dev/null
	if [[ ! $? -eq 0 ]]; then
		echo "* Installing git"
		sudo pacman -Syy git 
	fi
	echo "* Configuring git"
	cp git/gitconfig $HOME/.gitconfig 
}
function configure_herbstluftwm() {
	pacman -Qi herbstluftwm &> /dev/null
	if [[ ! $? -eq 0 ]]; then
		echo "* Installing herbstluftwm"
		sudo pacman -Syy herbstluftwm  artwiz-fonts dzen2
	fi
	echo "* Configuring Herbstluftwm"
	mkdir -p $HOME/.config/herbstluftwm/
	cp wm/herbstluftwm/* $HOME/.config/herbstluftwm/
}
function configure_vim() {
	pacman -Qi vim-runtime &> /dev/null
	if [[ ! $? -eq 0 ]]; then
		echo "* Installing vim"
		sudo pacman -Syy vim-runtime 
	fi
	echo "* Configuring vimrc"
	cp vim/vimrc $HOME/.vimrc
	echo "* Configuring vim color molokai"
	mkdir -p $HOME/.vim/colors/
	cp vim/colors/molokai.vim $HOME/.vim/colors/ 
}
function configure_xorg() {
	echo "* Configuring xinitrc and Xresources"
	cp xorg/xinitrc $HOME/.xinitrc
	cp xorg/Xresources $HOME/.Xresources
	echo "* Configuring Xdefaults (urxvt config-file)"
	cp xorg/Xdefaults-urxvt $HOME/.Xdefaults
}

function install_folders() {
	echo "* Creating folders archive/ src/ projects/ sandbox/" 
	mkdir -p $HOME/archive/
	mkdir -p $HOME/src/
	mkdir -p $HOME/projects/
	mkdir -p $HOME/sandbox/
}

for thing in $@; do
	case "$thing" in
		"bash") 
		configure_bash
		;;
		"dunst")
		configure_dunst
		;;
		"folders")
		install_folders
		;;
		"git")
		configure_git
		;;
		"herbstluftwm")
		configure_herbstluftwm
		;;
		"vim") 
		configure_vim
		;;
		"xorg") 
		configure_xorg
		;;
		"all") 
		configure_xorg
		configure_herbstluftwm
		configure_git
		configure_dunst
		configure_vim
		install_folders
		;;
	esac
done
