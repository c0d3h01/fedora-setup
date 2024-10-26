#!/bin/bash
set -e
set -o pipefail

# System update and base packages
sudo dnf update -y
sudo dnf install -y dnf-plugins-core

# Enable RPM Fusion repositories
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable VS Code repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Install development tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y cmake

# Install browsers
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser

# Install communication apps
sudo dnf install -y telegram-desktop discord

# Install Zoom
sudo rpm --import https://zoom.us/linux/download/pubkey
sudo dnf config-manager --add-repo https://zoom.us/linux/download/rpm/zoom.repo
sudo dnf install -y zoom

# Install development tools and IDEs
sudo dnf install -y code
sudo dnf install -y neovim
sudo dnf install -y android-tools
sudo dnf install -y java-latest-openjdk-devel
sudo dnf install -y nodejs npm

# Install system utilities
sudo dnf install -y \
    neofetch \
    htop \
    fastfetch \
    docker \
    docker-compose \
    libreoffice

# Install Ferdium using Flatpak
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.ferdium.Ferdium

# Install GitHub Desktop (using Flatpak since there's no official RPM)
flatpak install -y flathub io.github.shiftey.Desktop

# Enable services
sudo systemctl enable fstrim.timer
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker $USER

# Git configuration
git config --global user.name "c0d3h01"
git config --global user.email "harshalsawant2004h@gmail.com"

# DNF Configuration for faster downloads
sudo echo "fastestmirror=true" >> /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
sudo echo "defaultyes=true" >> /etc/dnf/dnf.conf

# Clean package cache
sudo dnf clean all

echo "Installation complete! Please reboot your system to ensure all changes take effect."
