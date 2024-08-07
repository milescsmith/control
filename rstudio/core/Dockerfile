# ARG PROJECT
# ARG _REPO
# ARG _SHIPYARD
# ARG _PARENT
# ARG _PARENT_VARIANT
# ARG _PARENT_VERSION
# FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}:${_PARENT_VERSION}
FROM bioconductor/bioconductor_docker:RELEASE_3_19-R-4.4.1

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
   apt-get install -y aptitude && \
   aptitude install --without-recommends -y -f --no-gui \
      curl \
      git-core \
      pandoc \
      pandoc-citeproc \
      libglu1-mesa-dev \
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

COPY --chown=rstudio:staff rclone.conf /home/rstudio/.rclone.conf

ENV INSTALLOPTS "upgrade = FALSE, ask = FALSE, checkBuilt = TRUE, verbose = TRUE, quiet = FALSE, configure.args = '--clean', clean = TRUE"

USER rstudio

COPY core_packages.R /home/rstudio/core_packages.R
RUN Rscript -e "source('/home/rstudio/core_packages.R')" && \
   Rscript -e "tinytex::install_tinytex()" && \
   rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
   rm /home/rstudio/core_packages.R

# Add Python packages through Miniconda
# Set the reticulate environment to be activated by default
# Note: currently, attempting to install pip dependencies by placing them
#    in the environment.yml definition causes docker to hang indefinitely.
#    Installing using pip avoids that issue
# ENV PATH /home/rstudio/micromamba/bin:$PATH
# COPY environment.yml /tmp/environment.yml
# SHELL [ "/usr/bin/bash", "-o", "pipefail", "-c" ]
# RUN curl micro.mamba.pm/install.sh | bash \
#     && source ~/.bashrc \
# RUN /home/rstudio/.local/bin/micromamba activate \
#    && /home/rstudio/.local/bin/micromamba install -y -n base -c conda-forge mamba python=3.9 \
#    && mamba init \
#    && mamba env create -f /tmp/environment.yml \
#    && mamba clean --all -y

COPY --chown=rstudio:staff pixi.lock /home/rstudio/env/pixi.lock
COPY --chown=rstudio:staff pixi.toml /home/rstudio/env/pixi.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash \
   #  && mv $HOME/.pixi/bin/pixi /usr/bin/ \
   && echo 'eval "$(pixi completion --shell bash)"' >> ~/.bashrc \
   && $HOME/.pixi/bin/pixi install --verbose --manifest-path /home/rstudio/env/pixi.toml \
   && $HOME/.pixi/bin/pixi clean cache --yes

# ENV PATH /home/rstudio/micromamba/conda/envs/reticulate/bin:$PATH
# ENV RETICULATE_PYTHON /home/rstudio/conda/envs/reticulate/bin

COPY user-settings /home/rstudio/.rstudio/monitored/user-settings/user-settings

RUN echo "export RETICULATE_AUTOCONFIGURE=0" >> /home/rstudio/.bashrc
RUN echo "export RETICULATE_AUTOCONFIGURE=0" >> /home/rstudio/.Renviron
#RUN echo "RETICULATE_PYTHON=/home/rstudio/conda/bin/python3" >> /home/rstudio/.Renviron

USER root
RUN chown --recursive rstudio:staff /home/rstudio/