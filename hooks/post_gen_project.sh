#!/bin/bash

set -e

## gh repo create will fail if origin exists
## i.e. if subdirectory of another git repository
## bypass this by creating a dummy repo without origin
## then delete the dummy repo

echo -en "\n## log in to github\n"
gh auth login

echo -en "\n## set git user information\n"
git config --global user.email "{{ cookiecutter.github_email }}"
git config --global user.name "{{ cookiecutter.github_fullname }}"

echo -en "\n## create public repo on GitHub\n"
git init &>/dev/null
gh repo create {{ cookiecutter.github_public_repo }} -y --public --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
rm -rf .git

echo -en "\n## create private repo on GitHub\n"
git init &>/dev/null 
gh repo create {{ cookiecutter.github_private_repo }} -y --private --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
rm -rf .git

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

echo -en "\n## GitHub and DockerHub tokens\n"

stty -echo
printf "GitHub personal access token is needed to access private repositories.\n"
printf "Create one by following directions found here:\n"
printf "https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token\n"
printf "Enter GitHub Personal Access Token: "
read MY_GITHUB_TOKEN
printf "\n\n"

printf "DockerHub access token is needed to upload Jupyter notebook docker images.\n"
printf "Create one by following directions found here:\n"
printf "https://docs.docker.com/docker-hub/access-tokens\n"
printf "Enter dockerHub access token: "
read DOCKERHUB_ACCESS_TOKEN
printf "\n\n"

printf "DockerHub access token is needed to upload Gradescope grader docker images.\n"
printf "Gradescope grader images are stored in a private repository\n"
printf "Enter grader image repository access token: "
read GRADER_ACCESS_TOKEN
printf "\n\n"
stty echo

echo -en "\nadding tokens to GitHub secrets\n"
gh secret set MY_GITHUB_TOKEN -b"${MY_GITHUB_TOKEN}"
gh secret set DOCKER_USERNAME -b"{{ cookiecutter.dockerhub_username }}"
gh secret set DOCKER_PASSWORD -b"${DOCKERHUB_ACCESS_TOKEN}"
gh secret set GRADER_PASSWORD -b"${GRADER_ACCESS_TOKEN}"

echo -en "\npushing grader files to private\n"
git add .
git push -u private-repo private

echo -en "\npushing again to docker builds notebook docker image)\n"
git checkout -b docker
git push -u private-repo docker

