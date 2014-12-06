#!/bin/bash
echo "========================================="
echo "	Downloading and installing BSPWM"
echo "========================================="

wget https://aur.archlinux.org/packages/bs/bspwm-git/bspwm-git.tar.gz -P /tmp/
tar xvfz /tmp/bspwm-git.tar.gz -C /tmp/
cd /tmp/bspwm-git/ && makepkg -f
sudo pacman -U /tmp/bspwm-git/bspwm-git*.pkg.tar.xz

echo "========================================="
echo "	Downloading and installing SXHKD"
echo "========================================="
wget https://aur.archlinux.org/packages/sx/sxhkd-git/sxhkd-git.tar.gz -P /tmp/
tar xvfz /tmp/sxhkd-git.tar.gz -C /tmp/
cd /tmp/sxhkd-git && makepkg -f
sudo pacman -U /tmp/sxhkd-git/sxhkd-git*.pkg.tar.xz

echo "-----------------------------------------"
echo " DONE."
