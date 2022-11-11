FROM {{ cookiecutter.base_jupyter_notebook_image }} AS prod

USER root

# install gh, misc. dependencies, set timezone
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl gnupg lmodern file && \
    \
    curl https://cli.github.com/packages/githubcli-archive-keyring.gpg | apt-key add - && \
    echo "deb [arch=amd64] https://cli.github.com/packages stable main" > \
        /etc/apt/sources.list.d/github.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends gh && \
    \
    ln -fs /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# install quarto
RUN curl --silent -L --fail \
        https://github.com/quarto-dev/quarto-cli/releases/download/v1.0.38/quarto-1.0.38-linux-amd64.deb > /tmp/quarto.deb && \
    apt-get update && \
    apt-get  install -y --no-install-recommends \
        libgdal-dev \
        texlive-fonts-extra \
        /tmp/quarto.deb

USER ${NB_UID}

RUN pip install --no-cache-dir \
        rise==5.7.1 \
        pdfkit==1.0.0 \
        PyPDF2==2.11.0 \
        nbgitpuller==1.1.0 \
        otter-grader==2.1.3 \
        jupyter-server-proxy==3.2.1 && \
    jupyter labextension install @jupyterlab/server-proxy@3.2.1 && \
    jupyter lab build

# otter-grader==4.0.2 \

FROM prod AS dev

USER root

ARG COPY_CONTEXT=.
COPY ${COPY_CONTEXT}/library-scripts/common-debian.sh /tmp/library-scripts/
COPY --chown="${NB_UID}:${NB_GID}" ${COPY_CONTEXT}/library-scripts/get-token.sh /opt/conda/bin/

RUN echo jovyan ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/jovyan \
    && chmod 0440 /etc/sudoers.d/jovyan

RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install

USER ${NB_UID}

RUN pip install hide_code cvxpy && \
    jupyter nbextension install --py hide_code --sys-prefix && \
    jupyter nbextension enable hide_code --py --sys-prefix && \
    jupyter serverextension enable --py hide_code --sys-prefix