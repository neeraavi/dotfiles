# using gihub behind proxy with ssh:

## (1) ssh keys

    ssh-keygen -t rsa -C "neeraavi"
use some easily identifiable name for file - not default
copy public  key to github ~/.ssh/id_rsa_github.pub
    ssh-add ~/.ssh/id_rsa_github  #private key


## (2) ssh proxy/command

    cat /home/$USER/.ssh/config
        Host github.com
              HostName github.com
              User git
              PreferredAuthentications publickey
              IdentityFile ~/.ssh/id_rsa_github
              #ProxyCommand connect -H 192.168.xx.yy:8080 %h %p   <---- use proxy address
              ProxyCommand /usr/local/bin/corkscrew proxy.example.com 8080 %h %p <------for arch

Test with command: 
        ssh -vT git@github.com

If connect is not available, install it:
    sudo apt-get install connect-proxy

For arch:
    sudo pacman -S corkscrew


## (3) create repo

    curl -u 'neeraavi' https://api.github.com/user/repos -d '{"name":"fourier"}'

    echo "# fourier" >> README.md
    git init
    git config user.name 'neeraavi'
    git config  http.proxy 192.168.xx.yy:8080
    git config  https.proxy 192.168.xx.yy:8080
     #git remote add origin https://github.com/neeraavi/fourier 
    git remote add origin git@github.com:neeraavi/fourier.git
     #v .git/config
    git add README.md
    git commit -m "first commit"
    git push -u origin master

    cat .gitignore
    bld/

# cloning

    git clone git@github.com:neeraavi/fourier.git
    git clone https://github.com/neeraavi/fourier.git
    git clone git@github.com:neeraavi/dotfiles.git
