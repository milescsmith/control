ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT_VERSION
ARG _PARENT_VARIANT
ARG _PARENT
FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}-${_PARENT_VARIANT}:${_PARENT_VERSION}

RUN apt update --fix-missing && \
   apt install --no-install-recommends -y \
      fastqtl \
      fastqtl-doc \
      libcairo2-dev \
      libhdf5-dev \
      liblapack-dev \
      qtltools \
      tini \
      vcftools && \
   cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
   apt-get clean && \
   rm -rf /tmp/downloaded_packages/* && \
   rm -rf /var/lib/apt/lists/*

USER rstudio
WORKDIR /home/rstudio

# Add Python packages through Miniconda
# Set the rtools environment to be activated by default
RUN mamba create -y -n jupyter jupyterlab

RUN mkdir -p /home/rstudio/logs/jupyter && \
   touch /home/rstudio/logs/jupyter/jupyter.log && \
   /home/rstudio/conda/envs/jupyter/bin/pip install environment_kernels && \
   conda install -n reticulate --update-all ipython
   # chmod u+x /home/rstudio/start-jupyter-service.sh && \
   # chown rstudio:rstudio /home/rstudio/start-jupyter-service.sh
COPY jupyter_notebook_config.py /home/rstudio/.jupyter/jupyter_notebook_config.py
COPY zeuscert.pem /home/rstudio/.jupyter/zeuscert.pem
COPY zeuskey.key /home/rstudio/.jupyter/zeuskey.key
RUN Rscript -e "BiocManager::install('IRkernel'); Sys.setenv(PATH = paste('/home/rstudio/conda/envs/jupyter/bin:',Sys.getenv('PATH'), sep=':')); IRkernel::installspec()"

USER root
RUN ln -s /home/rstudio/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
RUN chown --recursive rstudio:staff /home/rstudio/

USER rstudio
ENV SHELL=/bin/bash

RUN Rscript -e "BiocManager::install('tidyverse')"

# ENV TINI_VERSION v0.19.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
# RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD [ "mamba", "run", "-n", "jupyter", "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--config='/home/rstudio/.jupyter/jupyter_notebook_config.py'" ]