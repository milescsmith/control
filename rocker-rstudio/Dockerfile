ARG PROJECT
ARG _REPO
ARG _SHIPYARD
ARG _PARENT
ARG _PARENT_VARIANT
ARG _PARENT_VERSION
ARG _RSTUDIO_VERSION
#FROM ${_REPO}/${PROJECT}/${_SHIPYARD}/${_PARENT}/${_PARENT_VARIANT}:${_PARENT_VERSION}
FROM rocker/r-ver:${_PARENT_VERSION}

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rocker-org/rocker-versioned" \
      org.label-schema.vendor="Rocker Project" \
      maintainer="Carl Boettiger <cboettig@ropensci.org>"

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=${_RSTUDIO_VERSION}
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

COPY scripts/install_pandoc.sh /opt/install_pandoc.sh
COPY scripts/install_rstudio.sh /opt/install_rstudio.sh

RUN /opt/install_rstudio.sh
RUN /opt/install_pandoc.sh

COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json

EXPOSE 8787

CMD ["/init"]