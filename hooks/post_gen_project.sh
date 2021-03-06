#!/bin/bash

set -e

echo "begin post gen"

OS={{ cookiecutter.current_os }}

# try to install github cli if it doesn't exist
if [[ ! $(command -v gh) ]]
then

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

    echo "## create public repo"
    git init
    gh repo create {{ cookiecutter.github_public_repo }} -y --public --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
    rm -rf .git

    echo "## create private repo"
    git init
    gh repo create {{ cookiecutter.github_private_repo }} -y --private --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
    rm -rf .git

fi

# create dual repository structure 
if [[ $(command -v git) ]]
then

    git init

    git remote add public-repo https://github.com/{{ cookiecutter.github_public_repo }}.git
    git remote add private-repo https://github.com/{{ cookiecutter.github_private_repo }}.git

    # create initial commit for public repository
    echo "# {{ cookiecutter.class }} ({{ cookiecutter.term }})" >> README.md
    git add README.md
    git commit -m "first commit"
    git branch -M public
    git push -u public-repo public

    # mirror public repository in public repository
    git checkout -b private
    git push -u private-repo private

fi
