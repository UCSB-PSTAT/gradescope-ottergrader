FROM jupyter/minimal-notebook:ubuntu-22.04

USER ${NB_USER}

RUN wget https://github.com/cli/cli/releases/download/v2.20.0/gh_2.20.0_linux_amd64.tar.gz && \
    tar xvzf gh_2.20.0_linux_amd64.tar.gz && \
    mv gh_2.20.0_linux_amd64 gh && \
    rm -f gh_2.20.0_linux_amd64.tar.gz
ENV PATH=~/gh/bin:$PATH

RUN pip install \
        otter-grader \
        cookiecutter