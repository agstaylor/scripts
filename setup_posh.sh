#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

checkEnv(){
    ## Check if the current directory is writable.
    GITPATH="$(dirname "$(realpath "$0")")"
    if [[ ! -w ${GITPATH} ]];then
        echo -e "${RED}Can't write to ${GITPATH}${RC}"
        exit 1
    fi

    ## Check for requirements.
    REQUIREMENTS='wget sudo'
    if ! which ${REQUIREMENTS}>/dev/null;then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi

    ## Check if member of the wheel group.
    if ! groups|grep wheel>/dev/null;then
        echo -e "${RED}You need to be a member of the wheel group to run me!"
        exit 1
    fi
}

installDepend(){
    return
    ## Check for dependencies.
    #DEPENDENCIES='autojump bash bash-completion'
    #echo -e "${YELLOW}Installing dependencies...${RC}"
    #sudo dnf install -yq ${DEPENDENCIES}
}

installPosh(){

    if ! (sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh);then
        echo -e "${RED}Something went wrong during oh-my-posh install!${RC}"
        exit 1
    fi

    if ! (wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/blueish.omp.json -O blueish.omp.json);then
        echo -e "${RED}Something went wrong during oh-my-posh install!${RC}"
        exit 1
    fi

    if ! (sudo chmod +x /usr/local/bin/oh-my-posh);then
        echo -e "${RED}Something went wrong during oh-my-posh install!${RC}"
        exit 1
    fi
}

linkConfig(){
    ## Check if a bashrc file is already there.
    OLD_BASHRC="${HOME}/.bashrc"
    if [[ -e ${OLD_BASHRC} ]];then
        echo -e "${YELLOW}Moving old bash config file to ${HOME}/.bashrc.bak${RC}"
        if ! mv ${OLD_BASHRC} ${HOME}/.bashrc.bak;then
            echo -e "${RED}Can't move the old bash config file!${RC}"
            exit 1
        fi
    fi

    echo -e "${YELLOW}Linking new bash config file...${RC}"
    ## Make symbolic link.
    ln -svf ${GITPATH}/.bashrc ${HOME}/.bashrc
    ln -svf ${GITPATH}/starship.toml ${HOME}/.config/starship.toml
}

checkEnv
installDepend
installPosh
#if linkConfig;then
#    echo -e "${GREEN}Done!\nrestart your shell to see the changes.${RC}"
#else
#    echo -e "${RED}Something went wrong!${RC}"
#fi
