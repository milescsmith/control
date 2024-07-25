FROM gcr.io/scrna-196615/workerbee-ml:R-4.0.0b

USER root
RUN apt-get update --fix-missing && \
   apt-get install --no-install-recommends -y \
      libgdal-dev && \
   apt-get clean && \
   rm -rf /tmp/downloaded_packages/* && \
   rm -rf /var/lib/apt/lists/*

USER rstudio
WORKDIR /home/rstudio

COPY genetics_packages.R /home/rstudio/genetics_packages.R
RUN Rscript -e "source('/home/rstudio/genetics_packages.R')" && \
      rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
      rm /home/rstudio/genetics_packages.R

RUN ln -s /home/rstudio/workspace/ssh /home/rstudio/.ssh
RUN ln -s /home/rstudio/workspace/gitconfig /home/rstudio/.gitconfig

RUN Rscript -e "BiocManager::install('tidyverse')"

USER root
RUN chown --recursive rstudio:staff /home/rstudio/