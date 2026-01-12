#!/bin/bash

#!/bin/bash

echo "Instalando pacotes do repositório oficial (PACMAN)..."

sudo pacman -S --needed --noconfirm \
  base-devel \
  sudo \
  vim \
  nano \
  man-db \
  man-pages \
  util-linux \
  inetutils \
  net-tools \
  iproute2 \
  wget \
  curl \
  unzip \
  unrar \
  zip \
  p7zip \
  gzip \
  tar \
  lsof \
  rsync \
  which \
  htop \
  btop \
  bash-completion \
  mesa \
  vulkan-intel \
  brightnessctl \
  thunar-volman \
  blueman \
  udiskie \
  gvfs \
  file \
  efibootmgr \
  os-prober \
  scrot \
  flameshot \
  noto-fonts \
  noto-fonts-cjk \
  ttf-roboto \
  ttf-jetbrains-mono \
  ttf-jetbrains-mono-nerd \
  stow \
  flatpak \
  fish \
  zsh \
  alacritty \
  kitty \
  tmux \
  neovim \
  ripgrep \
  zoxide \
  nodejs \
  clang \
  python \
  rust \
  xorg-server \
  xorg-xinit \
  xorg-xrandr \
  xf86-input-libinput \
  xorg-xrdb \
  xorg-xset \
  libxinerama \
  okular \
  libreoffice-fresh-pt-br

echo "Pacotes pacman instalados com sucesso."
