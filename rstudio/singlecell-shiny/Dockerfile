ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}

USER rstudio
WORKDIR /home/rstudio

COPY shiny_packages.R /home/rstudio/shiny_packages.R
RUN Rscript -e "source('/home/rstudio/shiny_packages.R')" && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/shiny_packages.R

USER root
