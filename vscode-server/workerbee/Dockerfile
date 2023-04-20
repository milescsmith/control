FROM linuxserver/code-server:version-v3.10.0

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
    apt-get install \
        --no-install-recommends \
        --no-install-suggests \
        --fix-broken \
        --quiet \
        --assume-yes \
        --no-show-upgraded \
            gcc \
            g++ \
            git \
            libcurl4-openssl-dev \
            libopenmpi-dev \
            libssl-dev \
            libxml2-dev \
            locales \
            make \
            procps \
            python3-dev \
            python3-pip \
            r-base \
            rclone \
            zlib1g-dev && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /tmp/downloaded_packages/* && \
    rm -rf /var/lib/apt/lists/* && \
    # the deps for gtfToGenePred, see ldd gtfToGenePred
    apt-get purge && \
    apt-get autoclean

RUN Rscript -e "install.packages('BiocManager'); BiocManager::install(c('tidyverse', 'NOISeq', 'ggplotify'))"
ADD http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/gtfToGenePred /opt/gtfToGenePred/gtfToGenePred
RUN chmod +x /opt/gtfToGenePred/gtfToGenePred
ENV PATH=/opt/gtfToGenePred:$PATH

RUN git clone https://github.com/lh3/minimap2 /opt/minimap2 && \
    cd /opt/minimap2 &&\
    make && \
    chmod +x /opt/minimap2
ENV PATH=/opt/minimap2:$PATH

RUN git clone https://github.com/gpertea/gffread /opt/gffread && \
    cd /opt/gffread &&\
    make release && \
    chmod +x /opt/gffread
ENV PATH=/opt/gffread:$PATH

COPY config /home/root/.ssh/config
COPY rclone.conf /home/root/.config/rclone/rclone.conf