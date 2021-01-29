# On windows

```
msinfo32 and check bios mode --> Legacy 
Control panel -> power buttons
			Disable Fast-startup on windows
Download rufus, download arch iso image and prepare USB
```

Boot order -> First Linux SSD, then Windows SSD

# German Keyboard 

```
loadkeys de-latin1
localectl list-keymaps| grep de
```

# Internet

```
ip a  #2 LAN
ping google.com

In case of wifi:
wifi-menu
```

# Set time

```
timedatectl set-ntp true
timedatectl status
```

# Mirrors

```
pacman –Syy
pacman –S reflector
sudo reflector --country Germany --age 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman –Syy
```

# Install on Linux new SSD  /dev/sda 

## Partitioning

lsblk



To see more details of windows partition:
cfdisk /dev/sdb  #sdb -- where win is installed



choose /dev/sda (new SSD)



Select free space – create 2 partitions

 

Swap: 2x the size of memory = 32G

Primary

Select -> type -> check and select swap -> eg: 92 swap

 

Root partition – rest of space

Primary

Linux

Write

Quit

 

lsblk #to check

 

So, swap is on sda1 and / is on sda2 

## Make filesystem (format partitions):

```
mkswap /dev/sda1
swapon /dev/sda1

mkfs.ext4 /dev/sda2
```

## Mount partitions

```
mount /dev/sda2 /mnt 
```

## Mount windows partition in eg: sdb4

```
mkdir /mnt/windows
mount /dev/sdb4 /mnt/windows  # c: drive

#-- do same for d: drive --
mkdir /mnt/ddrive
mount /dev/sdb5 /mnt/ddrive  # d: drive
```

# Base Install

```
pacstrap /mnt base linux linux-firmware vim intel-ucode
```

# fstab

```
genfstab -U /mnt T >> /mnt/etc/fstab # -U use uuid 
cat /mnt/etc/fstab
```

We should see /, the root file system on /dev/sda2 and swap on /dev/sda1

# Chroot

To change into root directory of our new installation:

```
arch-chroot /mnt 
```

# Localization

## Timezone

```
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc   ##to set the hardware clock 
```

## Locale

```
vim /etc/locale.gen
  uncomment en_US.UTF-8 UTF-8

locale-gen 
```

```
echo "LANG=en_US.UTF-8 " >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
```

## hostname

```
vim /etc/hostname
  archvbox 
```

```
vim /etc/hosts

  127.0.0.1  localhost   #ip4
  ::1     localhost      #ip6   
  127.0.1.1  archvbox.localdomain archvbox
```

# Users and passwords

## set root pass

```
passwd 
```

## make another user 

```
useradd -m sn 
passwd sn   #set that user's password
usermod -aG wheel,audio,video,optical,storage sn
```

## provide sudo permissions

```
pacman -S sudo
EDITOR=vim visudo         
   #uncomment wheel grp
```

# Package install

```
pacman -S 
	grub 
	os-prober          # detect other OS
	ntfs-3g            # for mounting windows partitions
	dosfstools mtools  # fat
	networkmanager network-manager-applet 
	base-devel linux-headers 
	cups cupsd          # printer 
    git reflector dialog 
    xdg-util xdg-user-dirs

# wifi
# pacman –S wireless_tools wpa_supplicant

# bluetooth
# pacman –S bluez bluez-utils pulseaudio-bluetooth
```

# GRUB

HW with BIOS(i386), specify disk name(sda, sdb etc, not partition). Install GRUB on new disk where linux is installed (**sda**). 

```
grub-install --target=i386-pc /dev/sda --recheck -–debug

check windows is already mounted to /mnt/windows
ls /mnt/windows
#running os-prober will list windows also

grub-mkconfig -o /boot/grub/grub.cfg
#windows should show up
```

# Enable services

```
systemctl enable org.cups.cupsd
systemctl enable NetworkManager
#systemctl enable bluetooth
#systemctl enable sshd
```

# Reboot

```
exit      #the chroot by typing "exit"
umount –l -a
reboot 
```

Remember to remove the ISO USB.

# Check internet

```
ip a

If wifi:
nmtui 

#select and activate wifi conenction
```

# Graphics driver

```
sudo pacman -S xf86-video-intel 
```

# Display server

```
sudo pacman -S xorg 
```

# Display manager 

```
sudo pacman -S gdm
sudo systemctl enable gdm
```

# Desktop gnome

```
sudo pacman -S gnome gnome-extra xdg-utils
sudo pacman -S libreoffice simple-scan
```

# yay 

```
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg –si
```

# fonts  

```
yay -S nerd-fonts-mononoki ttf-ms-fonts
```

## copy over windows fonts from mount

```
sudo mkdir /usr/share/windows-fonts
sudo cp /windows/Windows/Fonts/* /usr/share/windows-fonts/
sudo chmod 644 /usr/share/windows-fonts/*
fc-cache –f
```

## printer drivers for brother laserjet

```
yay -S brlaser brscan4 sane

--or from git---
#brlaser brlaser-git
git clone https://github.com/pdewacht/brlaser.git
cd brlaser
cmake .
make
sudo make install
#if make fails, these may be needed:
pacman -S libcups2-dev libcupsimage2-dev
```

Start the CUPS interface by pasting `localhost:631` into you browser.



https://superuser.com/questions/1485925/how-does-one-install-a-brother-hl-2270dw-laser-printer-on-arch-linux-arm-and-ras

# Backup timeshift

```
yay –S timeshift
```

# Enable SSD cleanup

```
sudo systemctl enable fstrim.timer
```

# Other apps 

```
sudo pacman –S chromium archlinux-wallpapers	
git clone https://gitlab.com/dwt1/wallpapers.git
```

#  Other windows manager: dwm, dmenu, st

```
sudo pacman -S base-devel linux-headers xorg-server xorg-xinit xorg-xrandr xorg-xsetroot firefox nitrogen picom terminus-font git wget libx11 libxft autocutsel
```

## dmenu 

```
git clone https://gitlab.com/dwt1/dmenu-distrotube.git
cd dmenu-distrotube

#change st to alacritty
// static const char \*termcmd[] = { "alacritty", "-t", "Terminal", NULL };

makepkg -cf
sudo pacman -U \*.pkg.tar.zst
```

### alacritty config

```
cd 
mkdir -p .config/alacritty
cp /usr/share/doc/alacritty/example/alacritty.yml .config/alacritty/alacritty.yml
```

copy colors from https://github.com/aaron-williamson/base16-alacritty/tree/master/colors to that file

## dwm

```
First, to get correct dependencies:
yay -S dwm-distrotube-git dwmblocks-distrotube-git 
 
Then:
git clone https://gitlab.com/dwt1/dwm-distrotube.git
cd dwm-distrotube
# change Mod4Mask(windows key) to Mod1Mask(alt)
makepkg -cf
sudo pacman -U \*.pkg.tar.zst

-- For official package (if needed)--
wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz
tar -zxvf dwm-6.2.tar.gz
rm dwm-6.2.tar.gz
cd dwm-6.2
sudo make clean install
```

## xinitrc

```
vim .bash_profile

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
   startx
fi

# run xrandr -s to show settings and choose (1920x1200)

cd ~
cp /etc/X11/xinit/xinitrc .xinitrc
# scroll to end, delete last 5 lines and add lines below

setxkbmap de &          # key map
xrandr  --output Virtual1 --mode 1920x1200 & # resolution
nitrogen --restore &    # wallpaper
picom -f &              # compositor
autocutsel -fork &      # copy-paste
autocutsel -selection PRIMARY -fork &
exec dwm
```

# neeraavi

```
sudo pacman -S atool tree exa

cd 
mkdir -p progs/bin
mkdir tmp

git clone https://github.com/neeraavi/dotfiles.git
chmod +x /home/$USER/dotfiles/remDupes

ln -s dotfiles/aliases .aliases
ln -s dotfiles/functions .functions
ln -s dotfiles/exports .exports

#check and then --> rm .bashrc
ln -s dotfiles/bashrc .bashrc
ln -s dotfiles/aliases-off .aliases-off
ln -s dotfiles/tmux.conf .tmux
source ~/.aliases
```

## nvim

```
ln -s dotfiles/nvimrc .nvimrc
mkdir -p ~/.config/nvim
echo 'source ~/.nvimrc' > ~/.config/nvim/init.vim

#vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   
cd ~/tmp
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz    
ex nvim-linux64.tar.gz    
rm nvim-linux64.tar.gz  
ln -s ~/tmp/nvim-linux64/bin/nvim ~/progs/bin/nvim

```

## lf

```
cd ~/tmp
wget https://github.com/gokcehan/lf/releases/download/r19/lf-linux-amd64.tar.gz
ex lf-linux-amd64.tar.gz
rm lf-linux-amd64.tar.gz
mv lf ~/progs/bin/
```

## fzf

```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install  
```

## ripgrep

```
cd ~/tmp
wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz
ex ripgrep*
cp ripgrep*/rg ~/progs/bin/
rm -rf ripgrep*

cd ~/tmp
wget https://github.com/phiresky/ripgrep-all/releases/download/v0.9.6/ripgrep_all-v0.9.6-x86_64-unknown-linux-musl.tar.gz
ex ripgrep*
cp ripgrep*/rga ~/progs/bin/
rm -rf ripgrep_*
```

## ssh key pair

```
sudo pacman -S openssh
ssh-keygen -t rsa

From host: ~/.ssh/id_rsa.pub  
to remote ~/.ssh/authorized_keys  

#ssh server if needed
sudo systemctl status sshd
sudo systemctl start sshd
sudo systemctl enable sshd
```

