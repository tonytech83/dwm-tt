#!/bin/bash

# Func to install depandencies for Arch-based dist
install_depen() {
  echo "Installing dependencies for Arch Linux..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm \
  base-devel \
  libconfig \
  dbus \
  libev \
  libx11 \
  libxcb \
  libxext \
  libgl \
  libegl \
  libepoxy \
  meson \
  pcre2 \
  pixman \
  uthash \
  xcb-util-image \
  xcb-util-renderutil \
  xorgproto \
  cmake \
  libxft \
  libimlib2 \
  libxinerama \
  libxcb-res \
  xorg-xev \
  xorg-xbacklight \
  alsa-utils \
  unzip
  echo "Dependencies installed."
}

# Install some Nerd fonts
install_fonts() {
  sudo pacman -S --noconfirm noto-fonts-emoji
  echo "NotoColorEmoji installed."

  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
  unzip Meslo.zip -d Meslo
  unzip JetBrainsMono.zip -d JetBrainsMono
  mkdir -p ~/.local/share/fonts
  mv Meslo/*.ttf ~/.local/share/fonts/
  mv JetBrainsMono/*.ttf ~/.local/share/fonts/
  fc-cache -fv
  rm -rf Meslo/ JetBrainsMono/
  rm -f Meslo.zip JetBrainsMono.zip
  ehco "Meslo and JetBrainsMono fonts installed."
}

if [ -f /etc/os-release == ]; then
  . /etc/os-release
  if [ "$ID" == "arch" ]; then
    install_depen
  else
    echo "Unsupported distribution"
  fi
else
  echo "/etc/os-release not found. Unsupported distribution"
  exit 1
fi

# Function to install Picom animations
picom_animations() {
    echo "Installing Picom animations..."

    # Clone the repository in the home/build directory
    mkdir -p ~/build
    if [ ! -d ~/build/picom ]; then
        if ! git clone https://github.com/FT-Labs/picom.git ~/build/picom; then
            echo "Failed to clone the repository"
            return 1
        fi
    else
        echo "Repository already exists, skipping clone"
    fi

    cd ~/build/picom || { echo "Failed to change directory to picom"; return 1; }

    # Build the project
    if ! meson setup --buildtype=release build; then
        echo "Meson setup failed"
        return 1
    fi

    if ! ninja -C build; then
        echo "Ninja build failed"
        return 1
    fi

    # Install the built binary
    if ! sudo ninja -C build install; then
        echo "Failed to install the built binary"
        return 1
    fi

    echo "Picom animations installed successfully"
}

# Call picom animation function
picom_animations

# Install fonts
install_fonts

echo "All dependencies installed successfully."