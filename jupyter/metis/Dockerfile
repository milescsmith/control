# FROM index.docker.io/condaforge/miniforge3:23.11.0-0
# FROM index.docker.io/python:3.10.14-slim
FROM index.docker.io/ubuntu:jammy-20240227


ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG PYTHONVERSION=3.10.13
ARG NODE_MAJOR=20

# USER root
RUN useradd --create-home --shell /bin/bash ${USERNAME}

ENV DEBIAN_FRONTEND=noninteractive
RUN \
   apt update -qq \
   && apt install -y ca-certificates curl gnupg software-properties-common dirmngr build-essential wget \
   && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
   && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
   && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg \
   && echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
   && apt update --fix-missing \
   && apt install -y \
      bat \
      cmake \
      curl \
      fd-find \
      git \
      htop \
      libopenblas-dev \
      libcairo2-dev \
      libhdf5-dev \
      liblapack-dev \
      libharfbuzz-dev \
      libfribidi-dev \
      libfreetype6-dev \
      libpng-dev \
      libtiff5-dev \
      libjpeg-dev \
      libglu1-mesa-dev \
      libcgal-dev \
      libgit2-dev \
      libgsl-dev \
      libssh2-1-dev \
      libxkbcommon-x11-0 \
      nodejs \
      python3.10 \
      python3.10-dev \
      python3-pip \
      r-base=4.3.3-1.2204.0 \
      r-base-dev=4.3.3-1.2204.0 \
      r-base-core=4.3.3-1.2204.0 \
      r-base-html=4.3.3-1.2204.0 \
      r-recommended=4.3.3-1.2204.0 \
      rclone \
      ripgrep \
      sudo \
      vim \
      zsh \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
   && apt-get clean \
   && rm -rf /tmp/downloaded_packages/* \
   && rm -rf /var/lib/apt/lists/*


RUN chown --recursive :staff /opt

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV PATH="/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${USERNAME}/.local/bin"
COPY --chown=$USERNAME:$USERNAME .Rprofile /home/${USERNAME}/.Rprofile

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$HOME/.cargo/bin:${PATH}"
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc
COPY --chown=$USERNAME:$USERNAME pyproject.toml /tmp/
COPY requirements.txt /home/${USERNAME}/requirements.txt
RUN \
   curl https://bootstrap.pypa.io/pip/pip.pyz -o $HOME/pip.pyz \
   && python3 $HOME/pip.pyz install pip==24.0 setuptools==69.2.0 \
   # && touch /tmp/README.md \
   && export PATH="$HOME/.cargo/bin:${PATH}" \
   && pip install -r $HOME/requirements.txt \
   # && jupyter server extension enable widgetsnbextension \
   && mkdir -p /home/${USERNAME}/logs/jupyter \
   && mkdir -p /home/${USERNAME}/R/x86_64-pc-linux-gnu-library \
   && mkdir -p /home/${USERNAME}/.config/rclone

COPY --chown=$USERNAME:$USERNAME packages.R /tmp/packages.R
RUN Rscript -e "source('/tmp/packages.R'); IRkernel::installspec()"

COPY --chown=$USERNAME:$USERNAME rclone.conf /home/${USERNAME}/.config/rclone/rclone.conf
RUN  sed -i "s/USERNAME/${USERNAME}/g" /home/${USERNAME}/.config/rclone/rclone.conf
# COPY --chown=$USERNAME:$USERNAME jupyter_lab_config.py /home/${USERNAME}/.jupyter/jupyter_lab_config.py
COPY --chown=$USERNAME:$USERNAME jupyter_server_config.py /home/${USERNAME}/.jupyter/jupyter_server_config.py
COPY --chown=$USERNAME:$USERNAME jupyter.log /home/${USERNAME}/logs/jupyter/jupyter.log
COPY --chown=$USERNAME:$USERNAME zeuscert.pem /home/${USERNAME}/.jupyter/zeuscert.pem
COPY --chown=$USERNAME:$USERNAME zeuskey.key /home/${USERNAME}/.jupyter/zeuskey.key

WORKDIR /home/$USERNAME
ENV R_LIBS_USER="/home/$USERNAME/R/x86_64-pc-linux-gnu-library"
RUN mkdir /home/$USERNAME/workspace \
   && mkdir /home/$USERNAME/powerlevel10k

COPY --chown=$USERNAME:$USERNAME .zshrc /home/${USERNAME}/.zshrc

EXPOSE 8888
CMD [ "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=False"] 