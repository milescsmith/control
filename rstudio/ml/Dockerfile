ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
# FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}
FROM us-south1-docker.pkg.dev/guthridge-nih-strides-projects/tranquility-base/workerbee-bioc:4.4.1
USER rstudio
WORKDIR /home/rstudio

ENV INSTALLOPTS "upgrade = FALSE, ask = FALSE, checkBuilt = TRUE, verbose = TRUE, quiet = FALSE, configure.args = '--clean', clean = TRUE"

COPY ml_packages.R /home/rstudio/ml_packages.R
RUN Rscript -e "source('/home/rstudio/ml_packages.R')" \
      && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
      && rm /home/rstudio/ml_packages.R
      # && Rscript -e "webshot::install_phantomjs()"

# RUN apt update --fix-missing && \
#     apt install --no-install-recommends -y \
#         texlive-latex-recommended \
#         texlive-latex-extra \
#         lmodern \
#         texlive-full && \
#     apt-get clean && \
#     rm -rf /tmp/downloaded_packages/* && \
#     rm -rf /var/lib/apt/lists/*

USER root