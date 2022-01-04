#!/bin/env bash

echo "Installing necessary packages..."
sudo pacman -S xmonad xmonad-contrib xmonad-utils stalonetray xmobar
clear

echo "choose aur helper for installing picom-ibhagwan-git. 1. paru    2. yay"
read -r -p "select aur helper (1 or 2): " ans

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
  echo "Selected helper not installed. Now setup will install manually"
    git clone https://aur.archlinux.org/packages/picom-ibhagwan-git/ ~/.srcs/picom-ibhagwan-git
    (cd ~/.srcs/picom-ibhagwan-git/ && makepkg -si )
fi

$HELPER -S picom-ibhagwan-git
clear

#copy dotfiles

echo "copying stalonetray config file..."
cp ./config/stalonetrayrc ~/.stalonetrayrc

if [ -f ~/.xmobarrc ]; then
  echo "xmobar config detected. creating backup file and copying new config..."
  cp ~/.xmobarrc ~/.xmobarrc.bak;
  cp ./config/xmobarrc ~/.xmobarrc;
else
  echo "copying xmobar config file..."
  cp ./config/xmobarrc ~/.xmobarrc
fi

echo "copying fonts..."
mkdir -p ~/.local/share/fonts
cp -r ./fonts/* ~/.local/share/fonts/
fc-cache -f

mkdir -p ~/.config/

if [ -f ~/.config/picom.conf ]; then
  echo "Picom configs detected, backing up and copying new config..."
  cp ~/.config/picom.conf ~/.config/picom.conf.bak;
  cp ./config/picom.conf ~/.config/picom.conf;
else
  echo "Installing picom configs..."
  cp ./config/picom.conf ~/.config/picom.conf;
fi

if [ -d ~/.config/alacritty ]; then
  echo "Alacritty configs detected, backing up and copying new config..."
  cp ~/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml.bak;
  cp ./config/alacritty.yml ~/.config/alacritty/alacritty.yml;
else
  echo "Installing alacritty configs..."
  mkdir -p ~/.config/alacritty
  cp ./config/alacritty.yml ~/.config/alacritty/alacritty.yml;
fi

if [ -d ~/wallpapers ]; then
  echo "Adding wallpaper to ~/wallpapers..."
  cp ./wallpapers/0days.png ~/wallpapers/;
else
  echo "Installing wallpaper..."
  mkdir ~/wallpapers && cp -r ./wallpapers/* ~/wallpapers/;
fi

if [ -d ~/.config/xmonad ]; then
  echo "XMonad configs detected, backing up and copying new config..."
  mkdir ~/.config/xmonad.old && mv ~/.config/xmonad/* ~/.config/xmonad.old/
  cp ./config/xmonad.hs ~/.config/xmonad/;
else
  echo "Installing xmonad configs..."
  mkdir ~/.config/xmonad && cp ./config/xmonad.hs ~/.config/xmonad/;
fi

sleep 1;
xmonad --recompile
