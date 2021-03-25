# Autograder Autobuilder for Jupyter Notebook and R Markdown assignments in otter-grader format

This template repository structure makes autograding easier. The components assume the following technologies are used:
- Jupyter environment computing environment (Docker images)
- Python-based assignments in Jupyter notebook or R-based assignments in R markdown
- Assignments are in otter-grader format
- Gradescope is used for grading the assignments
- GitHub is used for version control

## Need: 
- GitHub personal access token
- DockerHub access token
- `ucsbgrader` access token (request from Sang)

[![image](https://user-images.githubusercontent.com/1441512/111580418-b7878480-8774-11eb-9668-e7938b0754ac.png)](https://youtu.be/D9ursARpQJk)

## Steps:
- Launch Binder session [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/UCSB-PSTAT/gradescope-ottergrader/main?urlpath=lab)
- Open terminal
- Run `cookiecutter gh:UCSB-PSTAT/gradescope-ottergrader`
