#!/usr/bin/bash
#CONFIGURE
INSTALL_USER=mumei
INSTALL_USER_FRIENDLYNAME="Nanashi Mumei"
INSTALL_HOSTNAME="Watashi-wa-Mushinronshadesu"

#Go to root DIR
cd /

#Set Locale
ln -sf '/usr/share/zoneinfo/America/Toronto' '/etc/localtime'
hwclock --systohc
rm /etc/locale.gen
echo 'en_CA.UTF-8 UTF-8' >> /etc/locale.gen
echo 'en_CA ISO-8859-1' >> /etc/locale.gen
echo 'LANG=en_CA.UTF-8' >> /etc/locale.conf
locale-gen

#Set Networking
echo '$INSTALL_HOSTNAME' >> /etc/hostname
echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
echo '127.0.1.1 $INSTALL_HOSTNAME.localdomain $INSTALL_HOSTNAME' >> /etc/hosts

#Add User
mkdir /home/$INSTALL_USER
cd /home/$INSTALL_USER
useradd $INSTALL_USER -c "$INSTALL_USER_FRIENDLYNAME" -s "/usr/bin/zsh"
usermod -a -G wheel $INSTALL_USER

	#Password prompt
	echo "Enter a password for user $INSTALL_USER"
	passwd $INSTALL_USER

#Install pacman wrapper (yay)
git clone 'https://aur.archlinux.org/yay.git'
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
cd yay
pacman-key --populate archlinux
chown $INSTALL_USER /home/$INSTALL_USER -R
chmod 700 /home/$INSTALL_USER -R
su $INSTALL_USER -c "makepkg -si"

cd /home/$INSTALL_USER

#Install packages
cp /INSTALL/pacman.conf /etc/pacman.conf
pacman -Sy
su $INSTALL_USER -c "yay -S flatpak wine wine-mono \
cmake gthumb ffmpeg firewalld networkmanager \
gimp network-manager-applet cups gvfs gvfs-smb \
<<<<<<< HEAD
htop pulseaudio pavucontrol lshw lvm2 bluez \
=======
htop pulseaudio pavucontrol lshw lvm2 curl bluez \
>>>>>>> 248ad12e56be221c86d9ed365ceb24800a1e3c99
make neofetch nm-connection-editor openssh xdotool \
python samba tar p7zip wireguard-tools vlc \
xorg compsize zip torbrowser-launcher unzip zsh wget \
transmission-gtk tree curl openresolv firefox cronie \
libreoffice-fresh pulseaudio-bluetooth pulseaudio-alsa \
python-pip conan p7zip-gui spotify-adblock-git \
realvnc-vnc-viewer"

#Install DE
echo "What Desktop Environment do you want installed? (all lowercase)"
<<<<<<< HEAD
echo "(gnome, kdeplasma, xfce4, i3, none)"
=======
echo "(gnome, plasma, xfce4, i3, none)"
>>>>>>> 248ad12e56be221c86d9ed365ceb24800a1e3c99
read DESKTOPENV

echo 'Install MEGAsync? (cloud storage) (Y/N)'
read MEGACONSENT

if [ $DESKTOPENV = 'gnome' ]; then
    echo "Installing GNOME"
    pacman -S gnome
    if [ $MEGACONSENT = 'y' ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S nautilus-megasync megasync-bin"
    else
        if [ $MEGACONSENT = 'Y' ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S nautilus-megasync megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

<<<<<<< HEAD
if [ $DESKTOPENV = 'kdeplasma' ]; then
=======
if [ $DESKTOPENV = 'plasma' ]; then
>>>>>>> 248ad12e56be221c86d9ed365ceb24800a1e3c99
    echo "Installing KDE Plasma"
    pacman -S plasma kate konsole dolphin
    if [ $MEGACONSENT = 'y' ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S dolphin-megasync-bin megasync-bin"
    else
        if [ $MEGACONSENT = 'Y' ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S dolphin-megasync-bin megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = 'xfce4' ]; then

    echo "Installing xfce4"
    pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
    if [ $MEGACONSENT = 'y' ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
    else
        if [ $MEGACONSENT = 'Y' ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = 'i3' ]; then
    echo "Installing i3"
    pacman -S i3-wm thunar rofi lightdm lightdm-gtk-greeter
    if [ $MEGACONSENT = 'y' ]; then
        echo "Installing MEGAsync"
        su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
    else
        if [ $MEGACONSENT = 'Y' ]; then
            echo "Installing MEGAsync"
            su su $INSTALL_USER -c "yay -S thunar-megasync-bin megasync-bin"
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

if [ $DESKTOPENV = 'none' ]; then
    echo "Not installing a Desktop Environment"
    if [ $MEGACONSENT = 'y' ]; then
        echo "MEGAsync is GUI only."
    else
        if [ $MEGACONSENT = 'Y' ]; then
            echo "MEGAsync is GUI only."
        else
            echo "Not installing MEGAsync"
        fi
    fi
fi

#Install Tenacity
echo "Would you like to install Tenacity? (Y/N)"
read TENACITY_CONSENT

if [ $TENACITY_CONSENT = 'y' ]; then
    echo 'Installing Tenacity'
    cp -r /INSTALL/wxgtk-dev /opt
    mkdir /home/$INSTALL_USER/tenacity-git
    cp -r /INSTALL/PKGBUILD /home/$INSTALL_USER/tenacity-git
    chown -R $INSTALL_USER:$INSTALL_USER /home/$INSTALL_USER/tenacity-git
    cd /home/$INSTALL_USER/tenacity-git
    su $INSTALL_USER -c "makepkg -si"
fi

if [ $TENACITY_CONSENT = 'Y' ]; then
    echo 'Installing Tenacity'
    cp -r /INSTALL/wxgtk-dev /opt
    mkdir /home/$INSTALL_USER/tenacity-git
    cp -r /INSTALL/PKGBUILD /home/$INSTALL_USER/tenacity-git
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
systemctl enable cups.service
systemctl enable cronie.service
systemctl enable sddm.service
systemctl enable firewalld.service
systemctl enable NetworkManager.service
systemctl enable tor
systemctl enable usbmuxd

if [ $DESKTOPENV = 'gnome' ]; then
    systemctl enable gdm
fi

if [ $DESKTOPENV = 'plasma' ]; then
    systemctl enable sddm
fi

if [ $DESKTOPENV = 'xfce4' ]; then
    systemctl enable lightdm
fi

if [ $DESKTOPENV = 'i3' ]; then
    systemctl enable lightdm
fi

#Create Key for lvm2 volume
dd bs=1024 count=4 if=/dev/urandom of=/crypto_keyfile.bin
cryptsetup luksAddKey /dev/sda2 /crypto_keyfile.bin
chmod 000 /crypto_keyfile.bin


#Patch configuration files (assuming the root volume is encrypted)
rm /etc/sudoers
cp /INSTALL/sudoers /INSTALL/mkinitcpio.conf /INSTALL/nanorc /etc
rm /etc/default/grub
cp /INSTALL/default/grub /etc/default 

#Install GRUB
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

#Make Initial RAMFS
mkinitcpio -P

#Turn on time syncing with network time protocol
timedatectl set-ntp 1

#Clean Up
rm -r /var/cache
rm -r /INSTALL/
rm -r /home/$INSTALL_USER/yay
ln -s /opt/wxgtk-dev/lib/* /lib

#exit if all commands exit with status code 0
exit 0
