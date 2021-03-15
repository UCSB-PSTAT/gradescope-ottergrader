#!/bin/bash

set -e

OS={{ cookiecutter.current_os }}

if [[ ! $(command -v gh) ]]
then

    echo -en "\n## try to install github cli\n"
    if [[ $OS -eq "Debian" ]]
    then

        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
        sudo apt-add-repository https://cli.github.com/packages
        sudo apt update
        sudo apt install -y gh

    elif [[ $OS -eq "macOS" ]]
    then

        if [[ $(command -v brew) ]]
        then

            brew install gh

        elif [[ $(command -v port) ]]
        then

            sudo port install gh

        else

            echo -en "\nbrew or macports not found\n"

        fi

    fi
fi

# try to create repositories
if [[ $(command -v gh) ]]
then

    ## gh repo create will fail if origin exists
    ## i.e. if subdirectory of another git repository
    ## bypass this by creating a dummy repo without origin
    ## then delete the dummy repo

    echo -en "\n## create public repo on GitHub\n"
    git init &>/dev/null
    gh repo create {{ cookiecutter.github_public_repo }} -y --public --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
    rm -rf .git

    echo -en "\n## create private repo on GitHub\n"
    git init &>/dev/null 
    gh repo create {{ cookiecutter.github_private_repo }} -y --private --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
    rm -rf .git

fi

# create dual repository structure 
if [[ $(command -v git) ]]
then

    echo -en "\n## create dual repostiory structure\n"
    echo -en "\ninitialize git repository\n"
    git init

    echo -en "\nadd public/private reomotes\n"
    git remote add public-repo https://github.com/{{ cookiecutter.github_public_repo }}.git
    git remote add private-repo https://github.com/{{ cookiecutter.github_private_repo }}.git

    echo -en "\ncreate/push public repository structure\n"
    echo "# {{ cookiecutter.class }} ({{ cookiecutter.term }})" >> README.md
    git add README.md
    git commit -m "first commit"
    git branch -M public
    git push -u public-repo public

    echo -en "\ncreate/push private repository structure\n"
    git checkout -b private
    git push -u private-repo private

    # stty -echo
    # printf "Password: "
    # read PASSWORD
    # stty echo
    # printf "\n"

    # gh secret set DOCKER_PASSWORD -b'asdfasdf'

fi
