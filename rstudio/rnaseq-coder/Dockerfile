ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN curl -fsSL https://code-server.dev/install.sh | sh

USER rstudio

COPY r_packages.R /home/rstudio/r_packages.R
RUN Rscript -e "source('/home/rstudio/r_packages.R')" && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    rm /home/rstudio/r_packages.R

RUN mamba install -y -n reticulate keras && \
    mamba run -n reticulate pip install git+https://github.com/milescsmith/pyhsiclasso

USER root
RUN chown --recursive rstudio:staff /home/rstudio/