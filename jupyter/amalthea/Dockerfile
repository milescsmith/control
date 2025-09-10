FROM index.docker.io/rust:1.89.0-slim-trixie

ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG NODE_MAJOR=23

RUN useradd --create-home --shell /bin/bash ${USERNAME}

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -qq \
    && apt install -y ca-certificates curl gnupg software-properties-common dirmngr build-essential wget \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-add-repository 'deb http://cloud.r-project.org/bin/linux/debian bookworm-cran40/' \
    && gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
    && gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | tee /etc/apt/trusted.gpg.d/cran_debian_key.asc \
    && apt update --fix-missing \
    && apt upgrade -y \
    && apt install -y \
        btop \
        clang \
        cmake \
        fd-find \
        gdb \
        git \
        htop \
        libbz2-dev \
        libcairo2-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libharfbuzz-dev \
        libhdf5-dev \
        libffi-dev \
        liblapack-dev \
        liblzma-dev \
        libncurses5-dev \
        libomp-dev \
        libopenblas-dev \
        libpng-dev \
        libgdbm-dev \
        libjpeg-dev \
        libreadline6-dev \
        libtiff5-dev \
        libsqlite3-dev \
        libssl-dev \
        lzma-dev \
        lcov \
        lzma \
        nodejs \
        r-base \
        r-base-dev \
        rclone \
        sudo \
        tk-dev \
        uuid-dev \
        vim \
        xvfb \
        zsh \
        zstd \
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/* \
    && rm -rf /var/lib/apt/lists/*


    # RUN curl -fsSL https://pixi.sh/install.sh | bash \
    #     && mv $HOME/.pixi/bin/pixi /usr/bin/ \
    #     && echo 'eval "$(pixi completion --shell bash)"' >> ~/.bashrc
    
USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN cargo install exa bat bottom du-dust ripgrep fd-find \
&& curl -LsSf https://astral.sh/uv/install.sh | sh
    
    ENV PYTHONPATH="/opt/python/install/bin"
    ENV PATH="$PATH:/opt/python/install/bin"

COPY --chown=${USERNAME}:${USERNAME} pyproject.toml /home/${USERNAME}/amalthea/pyproject.toml
RUN pip install --verbose /home/${USERNAME}/amalthea \
    && pip cache purge

RUN sudo chown --recursive ${USERNAME}:staff /home/${USERNAME}/ \
    && sudo chown --recursive :staff /opt

COPY --chown=${USERNAME}:${USERNAME} rclone.conf /home/${USERNAME}/.config/rclone/rclone.conf
RUN  sed -i "s/USERNAME/${USERNAME}/g" /home/${USERNAME}/.config/rclone/rclone.conf
# COPY --chown=${USERNAME}:${USERNAME} jupyter_lab_config.py /home/${USERNAME}/.jupyter/jupyter_lab_config.py
COPY --chown=${USERNAME}:${USERNAME} jupyter_server_config.py /home/${USERNAME}/.jupyter/jupyter_server_config.py
COPY --chown=${USERNAME}:${USERNAME} jupyter.log /home/${USERNAME}/logs/jupyter/jupyter.log
COPY --chown=${USERNAME}:${USERNAME} zeuscert.pem /home/${USERNAME}/.jupyter/zeuscert.pem
COPY --chown=${USERNAME}:${USERNAME} zeuskey.key /home/${USERNAME}/.jupyter/zeuskey.key

WORKDIR /home/${USERNAME}
ENV R_LIBS_USER="/home/${USERNAME}/R/x86_64-pc-linux-gnu-library"
RUN mkdir /home/${USERNAME}/workspace \
   && mkdir /home/${USERNAME}/powerlevel10k

COPY --chown=${USERNAME}:${USERNAME} .zshrc /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} overrides.json /home/${USERNAME}/env/.pixi/envs/default/share/jupyter/lab/settings/overrides.json

ENV PATH="$PATH:/home/${USERNAME}/.local/bin"
EXPOSE 8888
# NOTE for some reason, the correct value for the "${USERNAME}" alias in the CMD line is not being substituted
# so for the time being, I'm just setting a concrete value
ENTRYPOINT [ "jupyter" ]
CMD [ "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=False"] 