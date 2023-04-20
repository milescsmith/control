ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.269/quarto-1.2.269-linux-amd64.deb /opt/quarto.deb
RUN apt-get update --fix-missing && \
   apt-get install -y aptitude && \
   aptitude install --without-recommends -y -f --no-gui \
        htop \
        libglu1-mesa-dev \
        pandoc \
        pandoc-citeproc && \
    dpkg -i /opt/quarto.deb && \
    aptitude clean && \
    rm -rf /tmp/downloaded_packages/* && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

USER rstudio

COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
COPY r_packages.R /home/rstudio/r_packages.R
RUN Rscript -e "source('/home/rstudio/r_packages.R')" && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    rm /home/rstudio/r_packages.R

RUN ln -s /home/rstudio/workspace/ssh /home/rstudio/.ssh

USER root
RUN chown --recursive rstudio:staff /home/rstudio/