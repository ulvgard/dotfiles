#!/bin/bash
PKG_MGR_CMD="sudo pacman -S "

function configure_bspwm() {

	echo "* Configuring bspwm"
	mkdir -p $HOME/.config/bspwm
	cp wm/bspwm/bspwmrc $HOME/.config/bspwm/

	echo "* Configuring sxhkd"
	mkdir -p $HOME/.config/sxhkd/
	cp wm/bspwm/sxhkdrc $HOME/.config/sxhkd/
	chmod +x $HOME/.config/sxhkd/sxhkdrc
}

function configure_xorg() {
	echo "* Configuring xinitrc and Xresources"
	cp xorg/xinitrc $HOME/.xinitrc
	cp xorg/Xresources $HOME/.Xresources
}
function configure_vim() {
	echo "* Configuring vimrc"
	cp vim/vimrc $HOME/.vimrc
	echo "* Configuring vim color molokai"
	mkdir -p $HOME/.vim/colors/
	cp vim/colors/molokai.vim $HOME/.vim/colors/ 
}

function configure_bash() {
	echo "* Configuring bashrc"
	cp bash/bashrc $HOME/.bashrc
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
		"vim") 
		configure_vim
		;;
		"bash") 
		configure_bash
		;;
		"xorg") 
		configure_xorg
		;;
		"bspwm")
		configure_bspwm
		;;
		"folders")
		install_folders
		;;
		*) 
		configure_xorg
		configure_bspwm
		configure_vim
		install_folders
		;;
	esac
done
