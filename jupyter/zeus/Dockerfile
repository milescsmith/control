# Base for further python/rust containers
FROM index.docker.io/rust:1.89.0-slim-bookworm

# Alternatively, we might want to use this:
# FROM ghcr.io/astral-sh/uv:python3.12-trixie-slim

ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG NODE_MAJOR=23

RUN useradd --create-home --shell /bin/bash ${USERNAME}

ENV DEBIAN_FRONTEND=noninteractive
ENV LLVM_VERSION=19

ADD https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb /opt/cuda-keyring_1.1-1_all.deb

RUN apt update -qq \
    && apt install aptitude -y \
    && aptitude install -y \
        ca-certificates \
        curl \
        gnupg \
        dirmngr \
        build-essential \
        wget \
        clang-tidy-$LLVM_VERSION \
        clang-format-$LLVM_VERSION \
        clang-tools-$LLVM_VERSION \
        llvm-$LLVM_VERSION-dev \
        lld-$LLVM_VERSION \
        lldb-$LLVM_VERSION \
        llvm-$LLVM_VERSION-tools \
        libomp-$LLVM_VERSION-dev \
        libc++-$LLVM_VERSION-dev \
        libc++abi-$LLVM_VERSION-dev \
        libclang-common-$LLVM_VERSION-dev \
        libclang-$LLVM_VERSION-dev \
        libclang-cpp$LLVM_VERSION-dev \
        libunwind-$LLVM_VERSION-dev \
        libclang-rt-$LLVM_VERSION-dev \
        libpolly-$LLVM_VERSION-dev \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
    && gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | tee /etc/apt/trusted.gpg.d/cran_debian_key.asc \
    && echo 'deb [signed-by=/etc/apt/trusted.gpg.d/cran_debian_key.asc] http://cloud.r-project.org/bin/linux/debian bookworm-cran40/' >> /etc/apt/sources.list.d/sources.list \
    # && apt modernize-sources --assume-yes \
    && aptitude update \
    && aptitude full-upgrade -y \
    && aptitude install -y \
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
        libfreetype-dev \
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
        libreadline-dev \
        libtiff5-dev \
        libsqlite3-dev \
        libssl-dev \
        liblzma-dev \
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
    && dpkg -i /opt/cuda-keyring_1.1-1_all.deb \
    && aptitude update \
    && aptitude -y install \
        cuda-toolkit-12-8 \
        nvidia-container-toolkit \
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && aptitude autoclean \
    && aptitude clean \
    && rm -rf /tmp/downloaded_packages/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm /opt/cuda-keyring_1.1-1_all.deb

# RUN nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN cargo install eza bat bottom du-dust ripgrep fd-find skim \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" \
    && sudo chown --recursive ${USERNAME}:staff /home/${USERNAME}/ \
    && sudo chown --recursive :staff /opt

COPY --chown=${USERNAME}:${USERNAME} rclone.conf /home/${USERNAME}/.config/rclone/rclone.conf
RUN  sed -i "s/USERNAME/${USERNAME}/g" /home/${USERNAME}/.config/rclone/rclone.conf
COPY --chown=${USERNAME}:${USERNAME} zeuscert.pem /home/${USERNAME}/.jupyter/zeuscert.pem
COPY --chown=${USERNAME}:${USERNAME} zeuskey.key /home/${USERNAME}/.jupyter/zeuskey.key
COPY --chown=${USERNAME}:${USERNAME} .zshrc /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} .p10k.zsh /home/${USERNAME}/.p10k.zsh
COPY --chown=${USERNAME}:${USERNAME} key-bindings.zsh /home/${USERNAME}/.skim/key-bindings.zsh
RUN mkdir ${HOME}/.ssh

CMD [ "/usr/bin/zsh" ]