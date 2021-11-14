#!/usr/bin/bash
#Warning
echo "|--- ALL DATA ON /dev/sda WILL BE DESTROYED!           ---|"
echo "|---                                                   ---|"
echo "|--- PLEASE READ THIS BEFORE RUNNING THIS SCRIPT       ---|"
echo "|--- The installer options (such as username and       ---|"
echo "|--- hostname) can be changed by editing this          ---|"
echo "|--- file. This script also assumes that the           ---|"
echo "|--- installation media is encrypted. Please           ---|"
echo "|--- edit the script before running.                   ---|"
echo "|---  [CTRL+C to exit]   [Enter to continue]           ---|"
echo "|--- run 'nano /archinstaller/install_ch.sh' to edit   ---|"
read

#unmount the thumb drive if still mounted
umount -R /mnt

#making partitions
parted -s /dev/sda \
	mklabel msdos \
	mkpart primary ext4 1MB 512MB \
	mkpart primary 512MB 100%FREE

#Encrypt the second partition of the first detected SSD
echo "You will be asked for the same password a total of three times."
echo "Please enter the same password for all the prompts"
echo
echo "ENCRYPTING PARTITION /dev/sda2"
cryptsetup luksFormat -v -s 512 -h sha512 /dev/sda2
echo "OPENING /dev/sda2"
cryptsetup open --type luks /dev/sda2 lvm

#create the lvm2 virtual volumes
pvcreate /dev/mapper/lvm
vgcreate vgcrypt /dev/mapper/lvm
lvcreate -L 8G vgcrypt -n swap
lvcreate -L 30G vgcrypt -n root
lvcreate -l 100%FREE vgcrypt -n home

#format the volumes
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/mapper/vgcrypt-root
mkfs.ext4 /dev/mapper/vgcrypt-home
mkswap /dev/mapper/vgcrypt-swap

#mount volumes
swapon -s /dev/mapper/vgcrypt-swap
mount /dev/mapper/vgcrypt-root /mnt
mkdir /mnt/{boot,home}
mount /dev/mapper/vgcrypt-home /mnt/home
mount /dev/sda1 /mnt/boot

#Install base packages
pacstrap /mnt base base-devel linux linux-firmware linux-headers grub git nano zsh

#Generate file to mount filesystems at boot
genfstab -U /mnt >> /mnt/etc/fstab

#copy installation files to installation root directory
cp -r /archinstaller/ /mnt/archinstaller

#Run part II of the script
arch-chroot /mnt bash /archinstaller/install_ch.sh

#Reboot
reboot
