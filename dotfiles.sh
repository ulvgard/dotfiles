#!/bin/bash
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
	if [[ $(_fileExistAndEqualTo "~/.bashrc" "./bash/bashrc") -eq 0 ]]; then
		echo "[configured]"
	else
		echo "[not configured]"
	fi
}
function isDunstConfigured
{
	if [[ $(_fileExistAndEqualTo "~/.config/dunst/dunstrc" "./dunst/dunstrc") -eq 0 ]]; then
		echo "[configured]"
	else
		echo "[not configured]"
	fi
}
function isHLWMConfigured
{
	if [[ $(_fileExistAndEqualTo ~/.config/herbstluftwm/autostart ./wm/herbstluftwm/autostart) -eq 0 ]] && \
	   [[ $(_fileExistAndEqualTo ~/.config/herbstluftwm/panel.sh ./wm/herbstluftwm/panel.sh) -eq 0 ]]; then
		echo "[configured]"
	else
		echo "[not configured]"
	fi
}
function isVimConfigured
{
	echo $(_fileExistAndEqualTo "~/.vimrc" "./vim/vimrc")
}
function isXorgConfigured
{
	if  [[ $(_fileExistAndEqualTo ~/.xinitrc ./xorg/xinitrc) -eq 0 ]] && \
		[[ $(_fileExistAndEqualTo ~/.Xresources ./xorg/Xresources) -eq 0 ]]; then
		echo "[configured]"
	else
		echo "[not configured]"
	fi
}

function _checkIfInstalled
{
	pacman -Qi $1 &> /dev/null;
	if [  $? -eq 0 ]; then
		echo "[installed]"
	else
		echo "[uninstalled]"
	fi
}

function showInfo
{
	echo -e "bash\t\t"$(_checkIfInstalled bash)"\t"$(isBashConfigured)
	echo -e "dunst\t\t"$(_checkIfInstalled dunst)"\t"$(isDunstConfigured)
	echo -e "herbstluftwm\t"$(_checkIfInstalled herbstluftwm)"\t"$(isHLWMConfigured)
	echo -e "Xorg\t\t"$(_checkIfInstalled xorg-server)"\t"$(isXorgConfigured)

}
