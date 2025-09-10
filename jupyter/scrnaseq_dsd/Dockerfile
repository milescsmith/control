FROM index.docker.io/rust:slim-bookworm

ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN useradd --create-home --shell /bin/bash ${USERNAME}

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -qq \
    && apt install -y ca-certificates curl gnupg software-properties-common dirmngr build-essential wget \
    && apt update --fix-missing \
    && apt install -y \
        btop \
        cmake \
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
        sudo \
        tk-dev \
        uuid-dev \
        vim \
        xvfb \
        zsh \
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/* \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://pixi.sh/install.sh | bash \
    && mv $HOME/.pixi/bin/pixi /usr/bin/ \
    && echo 'eval "$(pixi completion --shell bash)"' >> ~/.bashrc

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN cargo install exa bat bottom du-dust ripgrep fd-find
COPY --chown=${USERNAME}:${USERNAME} pyproject.toml /home/${USERNAME}/env/pyproject.toml
RUN pixi install --verbose --manifest-path /home/${USERNAME}/env/pyproject.toml \
    && pixi run --manifest-path /home/${USERNAME}/env/pyproject.toml pip install git+https://github.com/milescsmith/scorphan@0.6.1 git+https://github.com/milescsmith/dsd@0.6.1 \
    && pixi clean cache --assume-yes


RUN sudo chown --recursive ${USERNAME}:staff /home/${USERNAME}/ \
    && sudo chown --recursive :staff /opt

COPY --chown=${USERNAME}:${USERNAME} jupyter_server_config.py /home/${USERNAME}/.jupyter/jupyter_server_config.py
COPY --chown=${USERNAME}:${USERNAME} jupyter.log /home/${USERNAME}/logs/jupyter/jupyter.log
COPY --chown=${USERNAME}:${USERNAME} zeuscert.pem /home/${USERNAME}/.jupyter/zeuscert.pem
COPY --chown=${USERNAME}:${USERNAME} zeuskey.key /home/${USERNAME}/.jupyter/zeuskey.key

WORKDIR /home/${USERNAME}
ENV R_LIBS_USER="/home/${USERNAME}/R/x86_64-pc-linux-gnu-library"
RUN mkdir /home/${USERNAME}/workspace \
   && mkdir /home/${USERNAME}/powerlevel10k

COPY --chown=${USERNAME}:${USERNAME} .zshrc /home/${USERNAME}/.zshrc

EXPOSE 8888
# NOTE for some reason, the correct value for the "${USERNAME}" alias in the CMD line is not being substituted
# so for the time being, I'm just setting a concrete value
ENTRYPOINT [ "pixi", "run", "--manifest-path", "/home/nemo/env/pyproject.toml", "jupyter" ]
CMD [ "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=False"] 