# plenty stolen from https://github.com/astral-sh/uv-docker-example/
FROM us-south1-docker.pkg.dev/guthridge-nih-strides-projects/tranquility-base/zeus:20250909

ARG USERNAME=nemo
ARG USER_UID=1000
ARG USER_GID=$USER_UID

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV UV_COMPILE_BYTECODE=1
# ENV UV_LINK_MODE=copy
ENV UV_TOOL_BIN_DIR=/usr/local/bin

# RUN --mount=type=cache,target=/home/nemo/.cache/uv \
RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    /home/${USERNAME}/.local/bin/uv venv --python 3.12 --seed --managed-python \
    # && ln -s $(/home/${USERNAME}/.local/bin/uv python find 3.12) $HOME/.local/bin/python \
    # && $HOME/.venv/bin/pip install uv \
    # && source /home/${USERNAME}.venv/bin/activate \
    && /home/${USERNAME}/.local/bin/uv pip install -r $HOME/requirements.txt
ENV PATH="$HOME/.venv/bin:$PATH"
ENV PYTHONPATH="$(dirname $(uv python find 3.12))"

ENV R_LIBS_USER="/home/${USERNAME}/R/x86_64-pc-linux-gnu-library"
RUN mkdir /home/${USERNAME}/workspace \
   && mkdir /home/${USERNAME}/powerlevel10k \
   && mkdir /home/${USERNAME}/.venv/share/jupyter/lab/settings \
   && ln -s /home/${USERNAME}/.venv/bin/jupyter /home/${USERNAME}/.local/bin/jupyter

COPY --chown=${USERNAME}:${USERNAME} overrides.json /home/${USERNAME}/.venv/share/jupyter/lab/settings/overrides.json

EXPOSE 8888
# NOTE for some reason, the correct value for the "${USERNAME}" alias in the CMD line is not being substituted
# so for the time being, I'm just setting a concrete value
ENV SHELL="/usr/bin/zsh"
ENTRYPOINT [ "/home/nemo/.venv/bin/jupyter" ]
CMD [ "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--notebook-dir=workspace", "--ServerApp.config_file=$HOME/.jupyter/jupyter_server_config.py", "--YDocExtension.disable_rtc=False"] 