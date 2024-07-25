ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}
USER rstudio
WORKDIR /home/rstudio

ENV INSTALLOPTS "upgrade = FALSE, ask = FALSE, checkBuilt = TRUE, verbose = TRUE, quiet = FALSE, configure.args = '--clean', clean = TRUE"

COPY core_bioconductor_packages.R /home/rstudio/core_bioconductor_packages.R
RUN Rscript -e "source('/home/rstudio/core_bioconductor_packages.R')" && \
      Rscript -e "BiocManager::install('apeglm', ${INSTALLOPTS})" && \
      Rscript -e "BiocManager::install('import', ${INSTALLOPTS})" && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/core_bioconductor_packages.R

USER root