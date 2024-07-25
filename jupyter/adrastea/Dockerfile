FROM index.docker.io/rust:slim-bullseye

ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG NODE_MAJOR=20

RUN useradd --create-home --shell /bin/bash nemo

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -qq \
    && apt install -y ca-certificates curl gnupg software-properties-common dirmngr build-essential wget \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt update --fix-missing \
    && apt install -y \
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
        rclone \
        sudo \
        tk-dev \
        uuid-dev \
        vim \
        xvfb \
        zsh \
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo nemo ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/nemo \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/* \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://pixi.sh/install.sh | bash \
    && mv $HOME/.pixi/bin/pixi /usr/bin/ \
    && echo 'eval "$(pixi completion --shell bash)"' >> ~/.bashrc

USER nemo
WORKDIR /home/nemo

COPY --chown=nemo:nemo mise.toml /home/nemo/.config/mise.toml
COPY --chown=nemo:nemo pyproject.toml /home/nemo/env/pyproject.toml
COPY --chown=nemo:nemo pixi.lock /home/nemo/env/pixi.lock
RUN cargo install mise exa bat bottom du-dust
    # && mise use -g python@3.11 \
    # && mise cache clear
RUN pixi install --verbose --manifest-path /home/nemo/env/pyproject.toml \
    && pixi clean cache --yes


RUN sudo chown --recursive nemo:staff /home/nemo/ \
    && sudo chown --recursive :staff /opt

COPY --chown=nemo:nemo rclone.conf /home/nemo/.config/rclone/rclone.conf
RUN  sed -i "s/USERNAME/nemo/g" /home/nemo/.config/rclone/rclone.conf
# COPY --chown=nemo:nemo jupyter_lab_config.py /home/nemo/.jupyter/jupyter_lab_config.py
COPY --chown=nemo:nemo jupyter_server_config.py /home/nemo/.jupyter/jupyter_server_config.py
COPY --chown=nemo:nemo jupyter.log /home/nemo/logs/jupyter/jupyter.log
COPY --chown=nemo:nemo zeuscert.pem /home/nemo/.jupyter/zeuscert.pem
COPY --chown=nemo:nemo zeuskey.key /home/nemo/.jupyter/zeuskey.key

WORKDIR /home/nemo
ENV R_LIBS_USER="/home/nemo/R/x86_64-pc-linux-gnu-library"
RUN mkdir /home/nemo/workspace \
   && mkdir /home/nemo/powerlevel10k

COPY --chown=nemo:nemo .zshrc /home/nemo/.zshrc

EXPOSE 8888
ENTRYPOINT [ "pixi", "run", "--manifest-path", "/home/nemo/env/pyproject.toml", "jupyter" ]
CMD [ "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=True"] 