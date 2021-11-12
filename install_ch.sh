#!/usr/bin/bash
if [ $(whoami) = "root" ]; then
    echo "You are root."
else
    echo "You are not root."
    exit
fi
#CONFIGURE
INSTALL_USER=mumei
INSTALL_USER_FRIENDLYNAME="Nanashi Mumei"
INSTALL_HOSTNAME="Watashi-wa-Mushinronshadesu"

echo username is $INSTALL_USER
echo user full name is $INSTALL_USER_FRIENDLYNAME
echo hostname is $INSTALL_HOSTNAME
echo "Are these settings correct? (Y/N)"
read $HOSTCONFIRM

if [ $HOSTCONFIRM = "y" ]; then
    echo "Username:"
    read INSTALL_USER
    echo "User full name:"
    read INSTALL_USER_FRIENDLYNAME
    echo "Hostname:"
    read INSTALL_HOSTNAME
else
    if [ $HOSTCONFIRM = "Y" ]; then
        echo "Username:"
        read INSTALL_USER
        echo "User full name:"
        read INSTALL_USER_FRIENDLYNAME
        echo "Hostname:"
        read INSTALL_HOSTNAME
    fi
fi

echo "It is too late to go back now!"

#Go to root DIR
cd /

#Set Locale

echo "What continent do you live in? (Africa, America, Antarctica, Asia, Australia, Europe)"
read CONTINENT
ls /usr/share/zoneinfo/$CONTINENT
echo "Out of these choices, what city corresponds to your timezone?"
read CITY

ln -sf "/usr/share/zoneinfo/$CONTINENT/$CITY" "/etc/localtime"
hwclock --systohc
rm /etc/locale.gen
echo "en_CA.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_CA ISO-8859-1" >> /etc/locale.gen
echo "LANG=en_CA.UTF-8" >> /etc/locale.conf
locale-gen

#Set Networking
echo "$INSTALL_HOSTNAME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 $INSTALL_HOSTNAME" >> /etc/hosts

#Add User
mkdir /home/$INSTALL_USER
cd /home/$INSTALL_USER
useradd $INSTALL_USER -c "$INSTALL_USER_FRIENDLYNAME" -s "/usr/bin/zsh"
usermod -a -G wheel $INSTALL_USER

	#Password prompt
	echo "Enter a password for user $INSTALL_USER"
	passwd $INSTALL_USER

#Install pacman wrapper (yay)
git clone "https://aur.archlinux.org/yay.git"
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cd yay
pacman-key --populate archlinux
chown $INSTALL_USER /home/$INSTALL_USER -R
chmod 700 /home/$INSTALL_USER -R
su $INSTALL_USER -c "makepkg -si"

cd /home/$INSTALL_USER

#Install essential packages
cp /archinstaller/pacman.conf /etc/pacman.conf
pacman -Sy cmake firewalld networkmanager htop lshw lvm2 \
bluez make neofetch nm-connection-editor openssh python tar \
p7zip python-pip unzip wget tree curl openresolv cronie

echo "Install nonessential packages (Y/N)"
read PACKAGECONSENT
if [ $PACKAGECONSENT = "y" ]; then
    pacman -S flatpak wine wine-mono ffmpeg gimp cups gvfs gvfs-smb \
pulseaudio pavucontrol gparted xdotool samba vlc xorg compsize \
zip torbrowser-launcher transmission-gtk firefox \
libreoffice-fresh pulseaudio-bluetooth pulseaudio-alsa
else
    if [ $PACKAGECONSENT = "Y" ]; then
        pacman -S flatpak wine wine-mono ffmpeg gimp cups gvfs gvfs-smb \
pulseaudio pavucontrol gparted xdotool samba vlc xorg compsize \
zip torbrowser-launcher transmission-gtk firefox \
libreoffice-fresh pulseaudio-bluetooth pulseaudio-alsa
    PACKAGECONSENT=y
    fi
fi

su $INSTALL_USER -c "yay -S conan"
su $INSTALL_USER -c "yay -S p7zip-gui"

echo "Install Spotify? (Y/N)"
read SPOTIFYCONSENT

if [ $SPOTIFYCONSENT = "y" ]; then
    su $INSTALL_USER -c "yay -S spotify-adblock-git"
else
    if [ $SPOTIFYCONSENT = "Y" ]; then
        su $INSTALL_USER -c "yay -S spotify-adblock-git"
    fi
fi

echo "Install a RealVNC Viewer? (Y/N)"
read VNCCONSENT

if [ $VNCCONSENT = "y" ]; then
su $INSTALL_USER -c "yay -S realvnc-vnc-viewer"
fi

#Install DE
echo "What Desktop Environment do you want installed? (all lowercase)"
echo "(gnome, kdeplasma, xfce4, i3, none)"
read DESKTOPENV

echo "Install MEGAsync? (cloud storage) (Y/N)"
read MEGACONSENT

if [ $DESKTOPENV = "gnome" ]; then
    echo "Installing GNOME"
    pacman -S gnome xorg --needed
    if [ $MEGACONSENT = "y" ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S nautilus-megasync megasync-bin"
    else
        if [ $MEGACONSENT = "Y" ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S nautilus-megasync megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = "kdeplasma" ]; then
    echo "Installing KDE Plasma"
    pacman -S plasma dolphin kde-utilities xorg --needed
    if [ $MEGACONSENT = "y" ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S dolphin-megasync-bin megasync-bin"
    else
        if [ $MEGACONSENT = "Y" ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S dolphin-megasync-bin megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = "xfce4" ]; then

    echo "Installing xfce4"
    pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter network-manager-applet xorg --needed
    if [ $MEGACONSENT = "y" ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
    else
        if [ $MEGACONSENT = "Y" ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = "i3" ]; then
    echo "Installing i3"
    pacman -S i3-wm thunar rofi lightdm lightdm-gtk-greeter network-manager-applet xorg --needed
    if [ $MEGACONSENT = "y" ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
    else
        if [ $MEGACONSENT = "Y" ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = "none" ]; then
    echo "Not installing a Desktop Environment"
    if [ $MEGACONSENT = "y" ]; then
        echo "MEGAsync is GUI only."
    else
        if [ $MEGACONSENT = "Y" ]; then
            echo "MEGAsync is GUI only."
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

#Install Tenacity
echo "Would you like to install Tenacity? (audio editor) (Y/N)"
read TENACITY_CONSENT

if [ $TENACITY_CONSENT = "y" ]; then
    echo "Installing Tenacity"
    cp -r /archinstaller/wxgtk-dev /opt
    mkdir /home/$INSTALL_USER/tenacity-git
    cp -r /archinstaller/PKGBUILD /home/$INSTALL_USER/tenacity-git
    chown -R $INSTALL_USER:$INSTALL_USER /home/$INSTALL_USER/tenacity-git
    cd /home/$INSTALL_USER/tenacity-git
    su $INSTALL_USER -c "makepkg -si"
fi

if [ $TENACITY_CONSENT = "Y" ]; then
    echo "Installing Tenacity"
    cp -r /archinstaller/wxgtk-dev /opt
    mkdir /home/$INSTALL_USER/tenacity-git
    cp -r /archinstaller/PKGBUILD /home/$INSTALL_USER/tenacity-git
    chown -R $INSTALL_USER:$INSTALL_USER /home/$INSTALL_USER/tenacity-git
    cd /home/$INSTALL_USER/tenacity-git
    su $INSTALL_USER -c "makepkg -si"
fi

#Return to root
cd /

#Install yt-dlp
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp

#Enable Essential Services
systemctl enable bluetooth.service
systemctl enable firewalld.service
systemctl enable NetworkManager.service
systemctl enable sshd

if [ $PACKAGECONSENT = "y" ]; then
    systemctl enable tor
    systemctl enable usbmuxd
    systemctl enable cups.service
    systemctl enable cronie.service

fi

if [ $DESKTOPENV = "gnome" ]; then
    systemctl enable gdm
fi

if [ $DESKTOPENV = "kdeplasma" ]; then
    systemctl enable sddm
fi

if [ $DESKTOPENV = "xfce4" ]; then
    systemctl enable lightdm
fi

if [ $DESKTOPENV = "i3" ]; then
    systemctl enable lightdm
fi

#Create Key for lvm2 volume
dd bs=1024 count=4 if=/dev/urandom of=/crypto_keyfile.bin
cryptsetup luksAddKey /dev/sda2 /crypto_keyfile.bin
chmod 000 /crypto_keyfile.bin


#Patch configuration files (assuming the root volume is encrypted)
rm /etc/sudoers
cp /archinstaller/sudoers /archinstaller/mkinitcpio.conf /archinstaller/nanorc /etc
rm /etc/default/grub
cp /archinstaller/default/grub /etc/default

#Install GRUB
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

#Make Initial RAMFS
mkinitcpio -P

#Turn on time syncing with network time protocol
timedatectl set-ntp 1

#Clean Up
rm -r /var/cache
rm -r /archinstaller/
rm -r /home/$INSTALL_USER/yay
ln -s /opt/wxgtk-dev/lib/* /lib

#exit if all commands exit with status code 0
exit 0
