# ARG PROJECT
# ARG _REPO
# ARG _SHIPYARD
# ARG _PARENT
# ARG _PARENT_VARIANT
# ARG _PARENT_VERSION
# FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}:${_PARENT_VERSION}
ARG USERNAME=rstudio
FROM bioconductor/bioconductor_docker:RELEASE_3_21-R-4.5.0

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
      libbz2-dev \
      libcairo2-dev \
      libfribidi-dev \
      libharfbuzz-dev \
      libhdf5-dev \
      libffi-dev \
      liblapack-dev \
      liblzma-dev \
      libncurses5-dev \
      libomp-dev \
      libpng-dev \
      libgdbm-dev \
      libjpeg-dev \
      libreadline6-dev \
      libtiff5-dev \
      libsqlite3-dev \
      libssl-dev \
      lzma-dev \
      lcov \
      ssh \
      btop \
      clang \
      cmake \
      fd-find \
      gdb \
      git \
      htop \
      nodejs \
      rclone \
      sudo \
      tk-dev \
      uuid-dev \
      vim \
      xvfb \
      zsh \
      zstd && \
   cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
   aptitude clean && \
   rm -rf /tmp/downloaded_packages/* && \
   rm -rf /var/lib/apt/lists/*

RUN wget -O /opt/python312.tar.zst https://github.com/astral-sh/python-build-standalone/releases/download/20250529/cpython-3.12.10+20250529-x86_64_v3-unknown-linux-gnu-pgo+lto-full.tar.zst \
   && tar --use-compress-program=unzstd -xvf /opt/python312.tar.zst -C /opt/ \
   && rm /opt/python312.tar.zst

ENV PYTHONPATH="/opt/python/install/bin"
ENV PATH="$PATH:/opt/python/install/bin"

RUN sudo chown --recursive ${USERNAME}:staff /home/rstudio/ \
   && sudo chown --recursive :staff /opt

ADD https://rclone.org/install.sh /home/${USERNAME}
RUN chmod +x /home/${USERNAME}/install.sh && \
  bash /home/${USERNAME}/install.sh

COPY --chown=${USERNAME}:staff rclone.conf /home/${USERNAME}/.rclone.conf

ENV INSTALLOPTS "upgrade = FALSE, ask = FALSE, checkBuilt = TRUE, verbose = TRUE, quiet = FALSE, configure.args = '--clean', clean = TRUE"

USER rstudio

COPY core_packages.R /home/rstudio/core_packages.R
RUN Rscript -e "source('/home/rstudio/core_packages.R')" && \
   Rscript -e "tinytex::install_tinytex()" && \
   rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
   rm /home/rstudio/core_packages.R

COPY user-settings /home/rstudio/.rstudio/monitored/user-settings/user-settings

RUN echo "export RETICULATE_AUTOCONFIGURE=0" >> /home/rstudio/.bashrc
RUN echo "export RETICULATE_AUTOCONFIGURE=0" >> /home/rstudio/.Renviron
#RUN echo "RETICULATE_PYTHON=/home/rstudio/conda/bin/python3" >> /home/rstudio/.Renviron

COPY --chown=${USERNAME}:${USERNAME} rclone.conf /home/${USERNAME}/.config/rclone/rclone.conf
RUN  sed -i "s/USERNAME/${USERNAME}/g" /home/${USERNAME}/.config/rclone/rclone.conf
RUN mkdir /home/${USERNAME}/workspace \
   && mkdir /home/${USERNAME}/powerlevel10k

COPY --chown=${USERNAME}:${USERNAME} .zshrc /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} overrides.json /home/${USERNAME}/env/.pixi/envs/default/share/jupyter/lab/settings/overrides.json

USER root
RUN chown --recursive rstudio:staff /home/rstudio/