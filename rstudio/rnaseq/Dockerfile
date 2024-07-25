ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT

FROM rust:1.69.0-buster AS builder
WORKDIR /app

RUN cargo install fd-find \
    && cargo install --features pcre2 ripgrep \
    && cargo install exa \
    && cargo install bat


FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.51/quarto-1.4.51-linux-amd64.deb /opt/quarto.deb 
RUN apt-get update --fix-missing && \
   apt-get install -y aptitude && \
   aptitude install --without-recommends -y -f --no-gui \
        htop \
        libglu1-mesa-dev \
        pandoc \
        pandoc-citeproc && \
    dpkg -i /opt/quarto.deb && \
    aptitude clean && \
    rm -rf /tmp/downloaded_packages/* && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

USER rstudio

COPY --from=builder /usr/local/cargo/bin /usr/local/bin
COPY r_packages.R /home/rstudio/r_packages.R
RUN Rscript -e "source('/home/rstudio/r_packages.R')" && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    rm /home/rstudio/r_packages.R
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
#   && source "$HOME/.cargo/env" \
#   && cargo install fd-find \
#   && cargo install ripgrep \
#   && cargo install exa \
#   && cargo install 

COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
COPY user-settings /home/rstudio/.local/share/rstudio/monitored/user-settings/user-settings
RUN ln -s /home/rstudio/workspace/ssh /home/rstudio/.ssh

USER root
RUN chown --recursive rstudio:staff /home/rstudio/