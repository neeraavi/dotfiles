#git clone https://github.com/neeraavi/dotfiles.git

sudo pacman -S atool tree exa

cd
mkdir -p progs/bin
mkdir tmp
chmod +x /home/$USER/dotfiles/remDupes

ln -s ~/dotfiles/aliases .aliases
ln -s ~/dotfiles/functions .functions
ln -s ~/dotfiles/exports .exports

#check and then --> rm .bashrc
rm .bashrc
ln -s ~/dotfiles/bashrc .bashrc
source ~/.aliases

mkdir -p ~/.config/lf
cd ~/.config/lf
ln -s ~/dotfiles/lfrc lfrc

mkdir -p ~/.config/zathura
cd ~/.config/zathura
ln -s ~/dotfiles/zathurarc zathurarc

## nvim
cd
ln -s dotfiles/nvimrc .nvimrc
mkdir -p ~/.config/nvim
echo 'source ~/.nvimrc' > ~/.config/nvim/init.vim

### vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cd ~/tmp
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
atool -x  nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
ln -s ~/tmp/nvim-linux64/bin/nvim ~/progs/bin/nvim

## lf
cd ~/tmp
wget https://github.com/gokcehan/lf/releases/download/r19/lf-linux-amd64.tar.gz
atool -x lf-linux-amd64.tar.gz
rm lf-linux-amd64.tar.gz
mv lf ~/progs/bin/

## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

## ripgrep
cd ~/tmp
wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz
atool -x ripgrep*
cp ripgrep*/rg ~/progs/bin/
rm -rf ripgrep*

cd ~/tmp
wget https://github.com/phiresky/ripgrep-all/releases/download/v0.9.6/ripgrep_all-v0.9.6-x86_64-unknown-linux-musl.tar.gz
atool -x ripgrep*
cp ripgrep*/rga ~/progs/bin/
rm -rf ripgrep_*

## ssh
sudo pacman -S openssh
ssh-keygen -t rsa

git clone git://git.suckless.org/st
cd st
wget https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff
patch < st-alpha-0.8.2.diff
cp config.def.h config.h
wget https://st.suckless.org/patches/delkey/st-delkey-20201112-4ef0cbd.diff
patch < st-delkey-20201112-4ef0cbd.diff
wget https://st.suckless.org/patches/scrollback/st-scrollback-20201205-4ef0cbd.diff
patch < st-scrollback-20201205-4ef0cbd.diff
wget https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20191024-a2c479c.diff
patch < st-scrollback-mouse-20191024-a2c479c.diff
wget https://st.suckless.org/patches/scrollback/st-scrollback-mouse-increment-0.8.2.diff
patch < st-scrollback-mouse-increment-0.8.2.diff
wget https://st.suckless.org/patches/selectioncolors/st-selectioncolors-0.8.2.diff
patch < st-selectioncolors-0.8.2.diff
#wget https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20200531-a2a7044.diff
patch < st-blinking_cursor-20200531-a2a7044.diff
sudo cp config.def.h config.h
sudo make clean install

cd ..
git clone git://git.suckless.org/dwm
cd dwm
sudo make clean install

cd ..
git clone git://git.suckless.org/dmenu
cd dmenu
sudo make clean install

