1. German kbd
-------------

loadkeys de-latin1
localectl list-keymaps| grep de


2. check net
-------------

ip a   #2 LAN
ping google.com

3. set time
-------------

timedatectl set-ntp true
timedatectl status

pacman -Syy


4. fdisk
-------------

fdisk -l   (lists out the partitions)
fdisk /dev/sda
g
n (new) 1  Enter +550M
n (new) 2  Enter +2G
n (new) 3  Enter Enter
t (change type) 1  1  (EFI)
t (change type) 2  19 (linux swap)
w (write)

In fdisk, "m" for help
In fdisk, "o" for DOS partition or "g" for GPT
In fdisk, "n" for add new partition
In fdisk, "p" for primary partition (if using MBR instead of GPT)
In fdisk, "t" to change partition type
In fdisk, "w" (write table to disk)


### Make filesystem
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

5. Base Install
----------------

mount /dev/sda3 /mnt  # (mounts it to mnt on live image)
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt T >> /mnt/etc/fstab

### Chroot
arch-chroot /mnt #(change into root directory of our new installation)

#### Timezone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc #(sets the hardware clock)

#### Locale
pacman -S vim
vim /etc/locale.gen
   uncomment en_US:UTF.8 UTF-8

locale-gen

#### hostname
vim  /etc/hostname
    archvbox

vim /etc/hosts

      127.0.0.1   localhost
      ::1         localhost
      127.0.1.1   archvbox.localdomain  localhost

#### Users and passwords

      passwd  #set root pass
      useradd -m sn #make another user
      passwd sn #set that user's password
      usermod -aG wheel,audio,video,optical,storage sn

#### sudo

      pacman -S sudo
      visudo #uncomment wheel grp
      sudo vim /etc/vsconsole.conf
           KEYMAP=de

6. GRUB
----------------

pacman -S grub efibootmgr dosfstools os-prober mtools #if doing UEFI
mkdir /boot/EFI #if doing UEFI
mount /dev/sda1 /boot/EFI  #Mount​ FAT32 EFI partition #if doing UEFI
grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck #if doing UEFI
grub-mkconfig -o /boot/grub/grub.cfg

7. Networking
----------------

      pacman -S networkmanager
      systemctl enable NetworkManager

# guestbox additions
All you have to do is install virtualbox-guest-utils with pacman. Don't do anything else. Don't even try to install Virtualbox Guest Utils from Virtualbox's menu, and don't mount the iso, that method works with many of the distros, but not with ArchLinux.

      sudo pacman -S virtualbox-guest-utils
      sudo VBoxClient-all
      sudo systemctl  enable --now vboxservice.service

# shared folder
just select in vbox, it will appear in /media/, but only with root access
To enable permission for regular user

      sudo usermod -aG vboxsf sn
      sudo chown -R sn /media/sf_tmp/

8. Reboot
----------------

      exit #the chroot by typing "exit"
      umount -l /mnt #unmounts /mnt
      shutdown now # reboot (or shutdown now if doing this in VirtualbBox)
Remember to detach the ISO in VirtualBox before reboot.


# dwm

## get packages
      sudo pacman -S reflector
      reflector --country Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
      sudo pacman -Syy
      sudo pacman -S base-devel xorg-server xorg-xinit xorg-xrandr xorg-xsetroot firefox nitrogen picom terminus-font git wget libx11  libxft

      git clone https://aur.archlinux.org/yay-git.git
      cd yay-git
      makepkg -si

      yay -S  st-distrotube-git dmenu-distrotube-git nerd-fonts-mononoki
      #yay -S dwm-distrotube-git

      #git clone git://git.suckless.org/st   #from above yay
      #git clone git://git.suckless.org/dmenu #from above yay
      #git clone git://git.suckless.org/dwm #no idea about shortcuts from above
      wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz
      tar -zxvf dwm-6.2.tar.gz
      cd dwm-6.2
      sudo make clean install

      git clone https://gitlab.com/dwt1/wallpapers.git
# xrandr -s to show settings and choose

vim .bash_profile

    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
     startx
    fi

      cd ~
      cp /etc/X11/xinit/xinitrc .xinitrc
scroll to end, delete last 5 lines and add lines below
      
      setxkbmap de &                               # key map
      xrandr   --output Virtual1 --mode 1920x1200 &  # resolution
      nitrogen --restore &                         # wallpaper
      picom -f &                                   # compositor
      exec dwm


# st

    sudo cp config.def.h config.h
    
    wget https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff
    patch -Np1 -i st-clipboard-0.8.3.diff
    
    wget https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff
    patch -Np1 -i st-alpha-0.8.2.diff
    wget https://st.suckless.org/patches/font2/st-font2-20190416-ba72400.diff
    patch -Np1 -i st-font2-20190416-ba72400.diff
    
    config.def.h 
 
# guestbox additions
All you have to do is install virtualbox-guest-utils with pacman. Don't do anything else. Don't even try to install Virtualbox Guest Utils from Virtualbox's menu, and don't mount the iso, that method works with many of the distros, but not with ArchLinux.

    sudo pacman -S virtualbox-guest-utils
    sudo VBoxClient-all
    sudo systemctl  enable --now vboxservice.service

# shared folder
just select in vbox, it will appear in /media/, but only with root access
To enable permission for regular user
    sudo usermod -aG vboxsf sn
    sudo chown -R sn /media/sf_tmp/

# gcal

    git clone https://aur.archlinux.org/gcal.git
    cd gcal
    makepkg -si
    
    alias cal="gcal -K --starting-day=1"
    alias hol="gcal -n -q DE_BW"
    alias moon='gcal -#0*d1#999_%O_%Z'
    alias sun='gcal --resource-file=$HOME/.gcal/astronomical -H no -ox'
    
    mkdir ~/.gcal/
    v ~/.gcal/astronomical
    
    ;--------------------------------------------------------------
    ;Ulm latitude 48.4011N
    ;Ulm longitude 9.9876E for gcal add 2 trailing zeros
    ;Ulm height above sea level 478m
    ;Winter time Ulm: GMT+1 Summer time Ulm: GMT+2
    $w=+60
    $s=+120
    $v=%2%4
    $p=0*d1#999
    $c=+48.4011+009.9876
    $x=~Sunrise    %o$c,$w | Sunset %s$c,$w ~Daylength %u$c,$w | Nightlength %z$c,$w
    $y=~Sunrise    %o$c,$s | Sunset %s$c,$s ~Daylength %u$c,$s | Nightlength %z$c,$s
    
    ; Winter time selector
    $b=%e#1980 %i0@a#0@b-1
    b=10sun9
    
    ; Summer time selector
    $a=%e#1980 %e0@a#0@b-1
    a=03sun9
    
    ; What will be written, through selectors.
    $p $a $x
    $p $b $y
    
    ;--------------------------------------------------------------

# behind proxy, to get pacman working
 uncomment the Xfercommand for wget in the /etc/pacman.conf and insert my proxy-settings to /etc/wgetrc - dont forget to set use_proxy=on uncomment the 3 lines for proxy.
  
