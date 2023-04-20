# ARG PROJECT
# ARG _REPO
# ARG _SHIPYARD
# ARG _PARENT
# ARG _PARENT_VARIANT
# ARG _PARENT_VERSION
# FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}:${_PARENT_VERSION}
FROM bioconductor/bioconductor_docker:RELEASE_3_16

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
   apt-get install -y aptitude && \
   aptitude install --without-recommends -y -f --no-gui \
      curl \
      git-core \
      libglu1-mesa-dev \
      pandoc \
      pandoc-citeproc \
      libcgal-dev \
      libgit2-dev \
      libgsl-dev \
      libfreetype6-dev \
      libopenblas-dev \
      libssh2-1-dev \
      libxkbcommon-x11-0 \
      rclone \
      ssh \
      vim && \
   cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
   aptitude clean && \
   rm -rf /tmp/downloaded_packages/* && \
   rm -rf /var/lib/apt/lists/*

ADD https://rclone.org/install.sh /home/rstudio
RUN chmod +x /home/rstudio/install.sh && \
  bash /home/rstudio/install.sh

COPY rclone.conf /home/rstudio/.rclone.conf
RUN chown rstudio:staff /home/rstudio/.rclone.conf 

ENV INSTALLOPTS "upgrade = FALSE, ask = FALSE, checkBuilt = TRUE, verbose = TRUE, quiet = FALSE, configure.args = '--clean', clean = TRUE"

USER rstudio

COPY core_packages.R /home/rstudio/core_packages.R
RUN Rscript -e "source('/home/rstudio/core_packages.R')" && \
   Rscript -e "tinytex::install_tinytex()" && \
   rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
   rm /home/rstudio/core_packages.R

ENV PATH /home/rstudio/conda/bin:$PATH
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/rstudio/miniconda.sh && \
   /bin/bash /home/rstudio/miniconda.sh -b -p /home/rstudio/conda && \
   rm /home/rstudio/miniconda.sh && \
   /home/rstudio/conda/bin/conda init && \
   conda update -n base -c defaults conda -y && \
   conda install -c conda-forge mamba && \
   mamba update -n base -c conda-forge mamba && \
   mamba clean --all -y

# Add Python packages through Miniconda
# Set the reticulate environment to be activated by default
# Note: currently, attempting to install pip dependencies by placing them
#    in the environment.yml definition causes docker to hang indefinitely.
#    Installing using pip avoids that issue
COPY environment.yml /tmp/environment.yml
RUN mamba env create -f /tmp/environment.yml && \
   mamba clean --all -y && \
   mamba init
ENV PATH /home/rstudio/conda/envs/reticulate/bin:$PATH
ENV RETICULATE_PYTHON /home/rstudio/conda/envs/reticulate/bin

COPY user-settings /home/rstudio/.rstudio/monitored/user-settings/user-settings
RUN mamba init bash
RUN echo "export RETICULATE_AUTOCONFIGURE=0" >> /home/rstudio/.bashrc
RUN echo "export RETICULATE_AUTOCONFIGURE=0" >> /home/rstudio/.Renviron
#RUN echo "RETICULATE_PYTHON=/home/rstudio/conda/bin/python3" >> /home/rstudio/.Renviron

USER root