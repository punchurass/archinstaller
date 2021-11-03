#!/usr/bin/bash
#CONFIGURE
INSTALL_USER=miku
INSTALL_USER_FRIENDLYNAME="Hatsune Miku"
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
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Sy
su $INSTALL_USER -c "yay -S wine wine-mono curl bluez \
cmake gthumb ffmpeg firewalld networkmanager \
gimp gnome-calculator network-manager-applet cups gvfs gvfs-smb \
htop pulseaudio pavucontrol lshw lvm2 \
make mousepad neofetch nm-connection-editor openssh \
python samba tar p7zip wireguard-tools vlc \
xorg compsize zip unzip zsh thunar wget transmission-gtk \
tree curl openresolv firefox cronie libreoffice-fresh \
pulseaudio-bluetooth pulseaudio-alsa python-pip \
gnome conan p7zip-gui wireguard-dkms \
tor-browser spotify-adblock-git \
networkmanager-wireguard realvnc-vnc-viewer \
brother-mfc-9560cdw thunar-megasync-bin megasync-bin"

#Install Tenacity
cp -r /INSTALL/wxgtk-dev /opt
cp -r /INSTALL/tenacity-git /home/$INSTALL_USER
chown -R $INSTALL_USER:$INSTALL_USER /home/$INSTALL_USER/tenacity-git
cd /home/$INSTALL_USER/tenacity-git
su $INSTALL_USER -c "makepkg -si"

#Return to root
cd /

#Install yt-dlp
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp

#Enable Essential Services
systemctl enable bluetooth.service
systemctl enable cups.service
systemctl enable cronie.service
systemctl enable gdm.service
systemctl enable firewalld.service
systemctl enable NetworkManager.service

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
