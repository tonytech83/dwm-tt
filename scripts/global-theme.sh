#!/bin/sh -e

RC='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'

install_theme_tools() {
    printf "${YELLOW}Installing theme tools (qt6ct and kvantum)...${RC}\n"
    pacman -S --needed --noconfirm qt6ct kvantum
}

configure_qt6ct() {
    printf "${YELLOW}Configuring qt6ct...${RC}\n"
    mkdir -p "$HOME/.config/qt6ct"
    cat <<EOF > "$HOME/.config/qt6ct/qt6ct.conf"
[Appearance]
style=kvantum
color_scheme=default
icon_theme=breeze
EOF
    printf "${GREEN}qt6ct configured successfully.${RC}\n"

    # Add QT_QPA_PLATFORMTHEME to /etc/environment
    if ! grep -q "QT_QPA_PLATFORMTHEME=qt6ct" /etc/environment; then
        printf "${YELLOW}Adding QT_QPA_PLATFORMTHEME to /etc/environment...${RC}\n"
        echo "QT_QPA_PLATFORMTHEME=qt6ct" | $ESCALATION_TOOL tee -a /etc/environment > /dev/null
        printf "${GREEN}QT_QPA_PLATFORMTHEME added to /etc/environment.${RC}\n"
    else
        printf "${GREEN}QT_QPA_PLATFORMTHEME already set in /etc/environment.${RC}\n"
    fi
}

configure_kvantum() {
    printf "${YELLOW}Configuring Kvantum...${RC}\n"
    mkdir -p "$HOME/.config/Kvantum"
    cat <<EOF > "$HOME/.config/Kvantum/kvantum.kvconfig"
[General]
theme=Breeze
EOF
    printf "${GREEN}Kvantum configured successfully.${RC}\n"
}

install_theme_tools
configure_qt6ct
configure_kvantum