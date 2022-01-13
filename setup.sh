#!/bin/env bash
# Arch linux xmonad setup script

#-----------------
red='\033[1;31m'
rset='\033[0m'
grn='\033[1;32m'
ylo='\033[1;33m'
blue='\033[1;34m'
#-----------------
clear
echo -e "$red Installing necessary packages... $rset"
sudo pacman -Syu xmonad xmonad-contrib xmonad-utils xmobar base-devel alacritty xwallpaper xorg-xsetroot xorg-xprop trayer

clear
echo -e "$grn choose aur helper for installing picom-ibhagwan-git. 1. paru    2. yay $rset"
read -r -p " select aur helper (1 or 2): " ans

if [ $ans -eq 1 ]
then
  HELPER="paru"
fi

if [ $ans -eq 2 ]
then
  HELPER="yay"
fi

# test if command is available, install if not
mkdir -p ~/.srcs

if ! command -v $HELPER &> /dev/null
then
  echo -e "$blue Selected helper not installed. Now setup will install manually $rset"
    git clone https://aur.archlinux.org/picom-ibhagwan-git.git ~/.srcs/picom-ibhagwan-git
    (cd ~/.srcs/picom-ibhagwan-git/ && makepkg -si )
else
  $HELPER -S picom-ibhagwan-git
fi

clear

#copy dotfiles


if [ -f ~/.xmobarrc ]; then
  echo -e "$ylo xmobar config detected. creating backup file and copying new config... $rset"
  cp ~/.xmobarrc ~/.xmobarrc.bak;
  cp ./config/xmobarrc ~/.xmobarrc;
else
  echo -e "$blue copying xmobar config file... $rset"
  cp ./config/xmobarrc ~/.xmobarrc
fi

echo -e "$blue copying fonts... $rset"
mkdir -p ~/.local/share/fonts
cp -r ./fonts/* ~/.local/share/fonts/
fc-cache -f

mkdir -p ~/.config/

if [ -f ~/.config/picom.conf ]; then
  echo -e "$ylo Picom configs detected, backing up and copying new config... $rset"
  cp ~/.config/picom.conf ~/.config/picom.conf.bak;
  cp ./config/picom.conf ~/.config/picom.conf;
else
  echo -e "$blue Installing picom configs... $rset"
  cp ./config/picom.conf ~/.config/picom.conf;
fi

if [ -d ~/.config/alacritty ]; then
  echo -e "$ylo Alacritty configs detected, backing up and copying new config...$rset"
  cp ~/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml.bak;
  cp ./config/alacritty.yml ~/.config/alacritty/alacritty.yml;
else
  echo -e "$blue Installing alacritty configs... $rset"
  mkdir -p ~/.config/alacritty
  cp ./config/alacritty.yml ~/.config/alacritty/alacritty.yml;
fi

if [ -d ~/wallpapers ]; then
  echo -e "$ylo Adding wallpaper to ~/wallpapers... $rset"
  cp ./wallpapers/* ~/wallpapers/;
else
  echo -e "$blue Installing wallpaper... $rset"
  mkdir ~/wallpapers && cp -r ./wallpapers/* ~/wallpapers/;
fi

if [ -d ~/.config/dunst ]; then
  echo -e "$ylo dunst configs detected, backing up and copying new config... $rset"
  mkdir ~/.config/dunst.bak && mv ~/.config/dunst/* ~/.config/dunst.bak/
  cp ./config/dunstrc ~/.config/dunst/;
else
  echo -e "$blue Installing dunst configs... $rset"
  mkdir ~/.config/dunst && cp ./config/dunstrc ~/.config/dunst/;
fi

if [ -d ~/.config/xmonad ]; then
  echo -e "$ylo XMonad configs detected, backing up and copying new config... $rset"
  mkdir ~/.config/xmonad.bak && mv ~/.config/xmonad/* ~/.config/xmonad.bak/
  cp ./config/xmonad.hs ~/.config/xmonad/;
  cp ./config/padding-icon.sh ~/.config/xmonad/;
else
  echo -e "$blue Installing xmonad configs... $rset"
  mkdir ~/.config/xmonad && cp ./config/xmonad.hs ~/.config/xmonad/;
  cp ./config/padding-icon.sh ~/.config/xmonad/;
fi

sleep 1;
if [ -d ~/.xmonad ]; then
  rm -rf ~/.xmonad && xmonad --recompile;
else
  xmonad --recompile
fi
