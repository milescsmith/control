ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}

USER root
RUN aptitude update && \
   aptitude install --without-recommends -y -f --no-gui \
      libgdal-dev \
      slurm-wlm && \
   aptitude clean && \
   rm -rf /tmp/downloaded_packages/* && \
   rm -rf /var/lib/apt/lists/*

USER rstudio
WORKDIR /home/rstudio

ARG _GITHUB_PAT
ENV GITHUB_PAT=${_GITHUB_PAT}
COPY future_packages.R /home/rstudio/future_packages.R
RUN Rscript /home/rstudio/future_packages.R && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/future_packages.R

USER root
RUN chown --recursive rstudio:staff /home/rstudio/
