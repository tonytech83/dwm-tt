<div align="center">
  <img src="https://seeklogo.com/images/D/dwm-logo-A5BEFB530B-seeklogo.com.png" alt="dwm-logo-bordered" width="195" height="90"/>
  
  # dwm - dynamic window manager
</div>

## _Overview_
This manual will guide you through the steps to set up a desktop environment beginning with a clean Arch-based installation. I will presume you have a good understanding of Linux-based operating systems and command-line interfaces. Given that you are reading this, it's likely you've watched some YouTube videos on 'tiling window managers,' which is typically where the journey begins. You are free to choose any window manager you prefer, but I will be demonstrating using Qtile as the initial tiling window manager since that was my starting point. Essentially, this is an overview of how I built my desktop environment from the ground up.gitlab.com/jped/suckless)

## _Arch Install_
I would make sure to have working internet:
```sh
pacman -S networkmanager
systemctl enable NetworkManager
```
After you log in, your internet connection should be functioning properly, provided that your computer is connected via Ethernet. If you're using a laptop that lacks Ethernet ports, you might have previously used iwctl during the setup process, but this tool won't be available unless you've explicitly installed it afterward. Don't worry, though—we've set up NetworkManager for you. Here’s how you can connect to a wireless LAN using this application:
```sh
# List all available networks
nmcli device wifi list
# Connect to your network
nmcli device wifi connect YOUR_SSID password YOUR_PASSWORD
```

### Xorg
Install dependencies:
```sh
sudo pacman -S --needed base-devel extra/git extra/libx11 extra/libxcb extra/libxinerama extra/libxft extra/imlib2
```
If you find yourself missing a library then this can usually be found by searching for the file name using pacman:
```sh
pacman -F Xlib-xcb.h
extra/libx11 1.6.12-1 [installed: 1.7.2-1]
usr/include/X11/Xlib-xcb.h
```
## Basic system utilities

### Wallpaper
```sh
sudo pacman -S feh
feh --bg-scale path/to/wallpaper
```

### Fonts
```sh
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts
```

### Audio
```sh
sudo pacman -S pulseaudio pavucontrol
```

For a better CLI experience though, I recommend using pamixer:
```sh
sudo pacman -S pamixer
```

## Further configuration and tools
### AUR helper
Now that you've installed some software that makes your computer easier to use without testing your patience, it's time to move on to more exciting tasks. First up, you should install an AUR helper. I recommend using yay:
```sh
sudo pacman -Syu
sudo pacman -S --needed base-devel

git clone https://aur.archlinux.org/yay.git
cd yay

makepkg -si
```

### File Manager
For a graphical one, I suggest thunar
```sh
sudo pacman -S thunar
```

### Pathes:
- barpadding
- bottomstack
- cfacts
- colorful tags
- cool autostart
- dragmfact
- dragcfact
- fibonacci
- gaplessgrid
- horizgrid
- movestack
- notitle
- preserveonrestart
- statuspadding
- status2d
- shiftview
- underlinetags
- vanitygaps
- winicon
- https://github.com/antoniosarosi/dotfiles/blob/master/README.md#further-configuration-and-tools
