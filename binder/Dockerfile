FROM jupyter/datascience-notebook:aec555e49be6

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN \
    # download R studio
    curl --silent -L --fail https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-1.2.1578-amd64.deb > /tmp/rstudio.deb && \
    echo '81f72d5f986a776eee0f11e69a536fb7 /tmp/rstudio.deb' | md5sum -c - && \
    \
    # install R studio
    apt-get update && \
    apt-get install -y --no-install-recommends /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_USER}

RUN pip install \
        jupyterlab-git==0.23.3 \
        cookiecutter==1.7.2 && \
    \
    pip install \
        jupyter-server-proxy==1.6.0 \
        jupyter-rsession-proxy==1.2.0 && \
    jupyter labextension install @jupyterlab/server-proxy

RUN wget https://github.com/cli/cli/releases/download/v1.7.0/gh_1.7.0_linux_amd64.tar.gz && \
    tar xvzf gh_1.7.0_linux_amd64.tar.gz && \
    mv gh_1.7.0_linux_amd64 gh && \
    rm -f gh_1.7.0_linux_amd64.tar.gz
    
ENV PATH=~/gh/bin:$PATH
