#!/bin/bash

set -e

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

    echo -en "\ncreate/push private repository structure\n"
    git checkout -b private

    echo -en "\ncommands to push to github\n\n"
    echo -en "\n  git checkout public\n"
    echo -en "\n  git push -u public-repo public\n"
    echo -en "\n  git checkout private\n"
    echo -en "\n  git push -u private-repo private\n"

fi
