FROM mambaorg/micromamba:1.5.1 as micromamba

# probably can eliminate this and just use the micromamba image
FROM nvcr.io/nvidia/tensorflow:23.09-tf2-py3

ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG PYTHONVERSION=3.10.13

# USER root
RUN useradd --create-home --shell /bin/bash ${USERNAME}

ENV DEBIAN_FRONTEND=noninteractive
RUN \
   apt update \
   && apt install -y --no-install-recommends software-properties-common dirmngr lsb-release \
   && echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
   && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
   && curl -fsSL https://deb.nodesource.com/setup_19.x | bash - \
   && apt update --fix-missing \
   && apt install -y \
      bat \
      fd-find \
      libopenblas-dev \
      libcairo2-dev \
      libhdf5-dev \
      liblapack-dev \
      cmake \
      sudo \
      nvidia-cuda-dev \
      nvidia-cuda-toolkit \ 
      libvdpau-doc \
      libvdpau-va-gl1 \
      nodejs \
      r-base \
      r-base-dev \
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

ENV CONDA_OVERRIDE_CUDA="11.8"
ENV OMPI_MCA_opal_cuda_support=true
ENV OMPI_MCA_pml="ucx" 
ENV OMPI_MCA_osc="ucx" 
ENV UCX_MEMTYPE_CACHE=n
COPY --from=micromamba "$MAMBA_EXE" "$MAMBA_EXE"
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_shell.sh /usr/local/bin/_dockerfile_shell.sh
COPY --from=micromamba /usr/local/bin/_entrypoint.sh /usr/local/bin/_entrypoint.sh
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_initialize_user_accounts.sh /usr/local/bin/_dockerfile_initialize_user_accounts.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_setup_root_prefix.sh /usr/local/bin/_dockerfile_setup_root_prefix.sh

RUN /usr/local/bin/_dockerfile_initialize_user_accounts.sh \
   && /usr/local/bin/_dockerfile_setup_root_prefix.sh \
   && chown --recursive ${MAMBA_USER}:staff /home/${MAMBA_USER}/

USER ${MAMBA_USER}
WORKDIR /home/${MAMBA_USER}

SHELL ["/usr/local/bin/_dockerfile_shell.sh"]

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]

ENV PATH="/opt/conda/bin:/opt/conda/condabin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${MAMBA_USER}/.local/bin"
COPY --chown=$USERNAME:$USERNAME sc.yaml /tmp/sc.yaml
COPY --chown=$USERNAME:$USERNAME .Rprofile /home/${USERNAME}/.Rprofile
COPY --chown=$USERNAME:$USERNAME packages.R /tmp/packages.R

RUN micromamba install -y -n base -f /tmp/sc.yaml \
   && micromamba install -y -n base -c conda-forge mamba \
   && micromamba clean --all --yes \
   && eval "$(micromamba shell hook --shell=bash)" \
   && micromamba activate \
   # && jupyter server extension enable widgetsnbextension \
   && mkdir -p /home/${USERNAME}/logs/jupyter \
   && mkdir -p /home/${USERNAME}/R/x86_64-pc-linux-gnu-library \
   && mkdir -p /home/${USERNAME}/.config/rclone \
   && touch /home/${USERNAME}/logs/jupyter/jupyter.log
RUN Rscript -e "source('/tmp/packages.R'); IRkernel::installspec()"

COPY --chown=$USERNAME:$USERNAME rclone.conf /home/${USERNAME}/.config/rclone/rclone.conf
RUN  sed -i "s/USERNAME/${USERNAME}/g" /home/${USERNAME}/.config/rclone/rclone.conf
# COPY --chown=$USERNAME:$USERNAME jupyter_lab_config.py /home/${USERNAME}/.jupyter/jupyter_lab_config.py
COPY --chown=$USERNAME:$USERNAME jupyter_server_config.py /home/${USERNAME}/.jupyter/jupyter_server_config.py
COPY --chown=$USERNAME:$USERNAME zeuscert.pem /home/${USERNAME}/.jupyter/zeuscert.pem
COPY --chown=$USERNAME:$USERNAME zeuskey.key /home/${USERNAME}/.jupyter/zeuskey.key

WORKDIR /home/$USERNAME
ENV R_LIBS_USER="/home/$USERNAME/R/x86_64-pc-linux-gnu-library"
RUN mkdir /home/$USERNAME/workspace \
   && mkdir /home/$USERNAME/powerlevel10k \
   && mkdir /home/$USERNAME/logs

COPY --chown=$USERNAME:$USERNAME .zshrc /home/${USERNAME}/.zshrc
COPY --chown=$USERNAME:$USERNAME mamba.sh /home/${USERNAME}/mamba.sh
# COPY --chown=$USERNAME:$USERNAME conda.sh /home/${USERNAME}/conda.sh
# COPY --chown=$USERNAME:$USERNAME .p10k.zsh /home/${USERNAME}/.p10k.zsh
# COPY --chown=$USERNAME:$USERNAME powerlevel10k.zsh-theme /home/${USERNAME}/powerlevel10k/powerlevel10k.zsh-theme


EXPOSE 8888
CMD [ "micromamba", "run", "-n", "base", "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=False"] 
# #, "--config='/home/${MAMBA_USER}/.jupyter/jupyter_notebook_config.py'" ]