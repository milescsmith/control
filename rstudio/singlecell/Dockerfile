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
      libgdal-dev && \
   aptitude clean && \
   rm -rf /tmp/downloaded_packages/* && \
   rm -rf /var/lib/apt/lists/*

USER rstudio
WORKDIR /home/rstudio

ARG _GITHUB_PAT
ENV GITHUB_PAT=${_GITHUB_PAT}
COPY scrna_packages.R /home/rstudio/scrna_packages.R
RUN Rscript /home/rstudio/scrna_packages.R && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/scrna_packages.R

COPY scrna_packages2.R /home/rstudio/scrna_packages.R
RUN Rscript /home/rstudio/scrna_packages.R && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/scrna_packages.R

COPY scrna_packages3.R /home/rstudio/scrna_packages.R
RUN Rscript /home/rstudio/scrna_packages.R && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/scrna_packages.R

COPY scrna_packages4.R /home/rstudio/scrna_packages.R
RUN Rscript /home/rstudio/scrna_packages.R && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/scrna_packages.R

COPY scrna_packages5.R /home/rstudio/scrna_packages.R
RUN Rscript /home/rstudio/scrna_packages.R && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/scrna_packages.R

RUN mamba run -n reticulate pip install git+https://github.com/milescsmith/ReductionWrappers
RUN ln -s /home/rstudio/workspace/ssh /home/rstudio/.ssh

USER root
RUN chown --recursive rstudio:staff /home/rstudio/