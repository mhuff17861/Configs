#!/bin/bash

if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   exit
fi

get_username () {
    echo ""  >&2
    echo ""  >&2
    echo "Hey there! I need your username (non-root) for shenanigans. If you would be so kind as to enter it below, that'd be great! Or you can watch the script crash and burn, that's cool too. I don't judge, fire is fun :)"  >&2
    read -p "Username: " uname
    echo ""  >&2
    echo $uname
}

install_nvim () {
    uname=$1
    apt install neovim
    cp ./scripts/init.vim /home/$uname/.config/nvim/
}

install_i3 () {
    uname=$1
    apt install i3
    cp ./static-configs/i3config /home/$uname/.config/i3/config
}

install_zsh () {
    uname=$1
    apt install zsh
    mkdir /home/$uname/.oh-my-zsh/custom
    mkdir /home/$uname/.oh-my-zsh/custom/themes

    # NEED TO ADD THING TO REPLACE {{USERNAME}}
    cp ./static-configs/.zshrc /home/$uname/.zshrc
    cp ./static-configs/jonathanxmicah.zsh-theme /home/$uname/.oh-my-zsh/custom/themes/jonathanxmicah.zsh-theme

    sudo -u $uname chsh -s $(which zsh)
    sudo -u $uname sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_tmux () {
    uname=$1
    apt install tmux
}

install_fnm () {
    apt install curl unzip
    curl -fsSL https://fnm.vercel.app/install | bash

    ## Still need to manually fun fnm install after sourcing
}

setup () {
    uname=$(get_username)
    apt install curl

    install_nvim $uname

    if [$1 == "i3"]; then
        install_i3 $uname
    fi

    install_tmux $uname
    install_zsh $uname
}

if [ $# -eq 0 ]; then
    setup
elif [ "$1" == "--i3" ]; then
    setup i3
fi