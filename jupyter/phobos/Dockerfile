FROM index.docker.io/condaforge/miniforge3:23.11.0-0

# probably can eliminate this and just use the micromamba image
# FROM python:3.11.8-bookworm

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
      fd-find \
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
      cmake \
      sudo \
      nodejs \
      r-base=4.3.3-1.2004.0 \
      r-base-dev=4.3.3-1.2004.0 \
      r-base-core=4.3.3-1.2004.0 \
      r-base-html=4.3.3-1.2004.0 \
      r-recommended=4.3.3-1.2004.0 \
      rclone \
      ripgrep \
      vim \
      zsh \
      htop \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
   && apt-get clean \
   && rm -rf /tmp/downloaded_packages/* \
   && rm -rf /var/lib/apt/lists/*

# if your image defaults to a non-root user, then you may want to make the
# next 3 ARG commands match the values in your image. You can get the values
# by running: docker run --rm -it my/image id -a
ARG MAMBA_USER=${USERNAME}
ARG MAMBA_USER_ID=${USER_UID}
ARG MAMBA_USER_GID=${USER_GID}
ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/bin/micromamba"

# COPY --from=micromamba "$MAMBA_EXE" "$MAMBA_EXE"
# COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
# COPY --from=micromamba /usr/local/bin/_dockerfile_shell.sh /usr/local/bin/_dockerfile_shell.sh
# COPY --from=micromamba /usr/local/bin/_entrypoint.sh /usr/local/bin/_entrypoint.sh
# COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
# COPY --from=micromamba /usr/local/bin/_dockerfile_initialize_user_accounts.sh /usr/local/bin/_dockerfile_initialize_user_accounts.sh
# COPY --from=micromamba /usr/local/bin/_dockerfile_setup_root_prefix.sh /usr/local/bin/_dockerfile_setup_root_prefix.sh

# RUN /usr/local/bin/_dockerfile_initialize_user_accounts.sh \
#    && /usr/local/bin/_dockerfile_setup_root_prefix.sh \
RUN chown --recursive ${MAMBA_USER}:staff /home/${MAMBA_USER}/ \
   && chown --recursive ${MAMBA_USER}:staff ${MAMBA_ROOT_PREFIX}/ \
   && chown --recursive :staff /opt

USER ${MAMBA_USER}
WORKDIR /home/${MAMBA_USER}

ENV PATH="/opt/conda/bin:/opt/conda/condabin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${MAMBA_USER}/.local/bin"
COPY --chown=$USERNAME:$USERNAME .Rprofile /home/${USERNAME}/.Rprofile

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$HOME/.cargo/bin:${PATH}"
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc
COPY --chown=$USERNAME:$USERNAME sc.yaml /tmp/sc.yaml
RUN \
   mamba env update -n base --file /tmp/sc.yaml \
   && mamba install --yes -n base -c conda-forge pkg-config \
   && mamba clean --all --yes \
   # && jupyter server extension enable widgetsnbextension \
   && mkdir -p /home/${USERNAME}/logs/jupyter \
   && mkdir -p /home/${USERNAME}/R/x86_64-pc-linux-gnu-library \
   && mkdir -p /home/${USERNAME}/.config/rclone

COPY --chown=$USERNAME:$USERNAME packages.R /tmp/packages.R
RUN Rscript -e "source('/tmp/packages.R'); IRkernel::installspec()"
ENV PATH="/home/nemo/.cargo/bin:${PATH}"
COPY --chown=$USERNAME:$USERNAME requirements.txt /tmp/requirements.txt
RUN mamba run -n base pip install -r /tmp/requirements.txt \
   && mamba run -n base pip install --upgrade tensorflow \
   && mamba run -n base pip install --upgrade tensorflow-probability \
   && mamba run -n base pip install -i https://test.pypi.org/simple/ vaeda==0.0.30

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
COPY --chown=$USERNAME:$USERNAME mamba.sh /home/${USERNAME}/mamba.sh

EXPOSE 8888
CMD [ "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=False"] 
#, "--config='/home/${MAMBA_USER}/.jupyter/jupyter_notebook_config.py'" ]