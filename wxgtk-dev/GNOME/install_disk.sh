cryptsetup luksFormat -v -s 512 -h sha512 /dev/sda2
cryptsetup open --type luks /dev/sda2 lvm
pvcreate /dev/mapper/lvm
vgcreate vg /dev/mapper/lvm
lvcreate -L 8G vg -n swap
lvcreate -L 30G vg -n root
lvcreate -l 100%FREE vg -n btrfs
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/mapper/vg-root
mkfs.btrfs /dev/mapper/vg-btrfs
mkswap /dev/mapper/vg-swap
swapon -s /dev/mapper/vg-swap
mount /dev/mapper/vg-btrfs /mnt
btrfs subvolume create /mnt/@home
umount /mnt
mount /dev/mapper/vg-root /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount -o noatime,compress=lzo,space_cache,subvol=@home /dev/mapper/vg-btrfs /mnt/home