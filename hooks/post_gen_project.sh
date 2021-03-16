#!/bin/bash

set -e

## gh repo create will fail if origin exists
## i.e. if subdirectory of another git repository
## bypass this by creating a dummy repo without origin
## then delete the dummy repo

echo -en "\n## log in to github\n"
gh auth login

echo -en "\n## set git user information\n"
printf "Enter a name for 'git config': "
read GITHUB_NAME
printf "Enter a email for 'git config': "
read GITHUB_EMAIL

git config --global user.email "${GITHUB_EMAIL}"
git config --global user.name "${GITHUB_NAME}"

echo -en "\n## create repositories GitHub\n"
git init &>/dev/null
gh repo create {{ cookiecutter.github_public_repo }} -y --public --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
rm -rf .git

git init &>/dev/null 
gh repo create {{ cookiecutter.github_private_repo }} -y --private --description "{{ cookiecutter.class }} ({{ cookiecutter.term }})"
rm -rf .git

echo -en "\n## initialize git repository\n"
git init

echo -en "\n# add public/private remotes\n"
git remote add public-repo https://github.com/{{ cookiecutter.github_public_repo }}.git
git remote add private-repo https://github.com/{{ cookiecutter.github_private_repo }}.git
git remote -v

echo -en "\n## create/push public repository\n"
echo "# {{ cookiecutter.class }} ({{ cookiecutter.term }})" >> README.md
git add README.md
git commit -m "first commit"
git branch -M public
git push -u public-repo public

echo -en "\n## create/push private repository\n"
git checkout -b private

echo -en "\n# GitHub and DockerHub tokens\n"

echo -en "\nGitHub personal access token allows access to private repositories.\n"
echo -en "Instructions: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token\n"
echo -en "Enter GitHub Personal Access Token: "
read MY_GITHUB_TOKEN
echo -en "\n"

echo -en "\nDockerHub access token for uploading Jupyter notebook docker images.\n"
echo -en "Instructions: https://docs.docker.com/docker-hub/access-tokens\n"
echo -en "Enter your DockerHub access token: "
read DOCKERHUB_ACCESS_TOKEN
echo -en "\n"

echo -en "\nGradescope grader images are stored privately.\n"
echo -en "Request a token from Sang-Yun Oh\n"
echo -en "Enter access token for 'ucsbgrader' user: "
read GRADER_ACCESS_TOKEN
echo -en "\n"

echo -en "\n# adding tokens to GitHub secrets\n"
gh secret set MY_GITHUB_TOKEN -b"${MY_GITHUB_TOKEN}"
gh secret set DOCKER_USERNAME -b"{{ cookiecutter.dockerhub_username }}"
gh secret set DOCKER_PASSWORD -b"${DOCKERHUB_ACCESS_TOKEN}"
gh secret set GRADER_PASSWORD -b"${GRADER_ACCESS_TOKEN}"

echo -en "\n# pushing grader files to private\n"
git add .
git commit -m"initial grader files"
git push -u private-repo private

echo -en "\n# pushing again to docker builds notebook docker image\n"
git checkout -b docker
git push -u private-repo docker

