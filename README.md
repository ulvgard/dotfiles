dotfiles
========

configuration scripts, deployment and themes

Checking status
===============

The script `dotfiles.sh` contain functions to check the system config files.
Example:
```
$> . dotfiles.sh
$> showConfigStatus
bash        [installed] [not configured]
    -> ~/.bashrc
dunst      [installed] [not configured]
    -> ~/.config/dunst/dunstrc
herbstluftwm  [installed] [not configured]
    -> ~/.config/herbstluftwm/autostart 
    -> ~/.config/herbstluftwm/panel.sh
Git     [installed] [not configured]
    -> ~/.gitconfig
Vim        [installed] [not configured]
    -> ~/.vimrc
Xorg      [installed] [not configured]
    -> ~/.xinitrc 
    -> ~/.Xresources
```

You can use `install.sh` to install a (archlinux) package and configuration.

```
$> ./install.sh bash
* Installing bash 
* Configuring bashrc
```
