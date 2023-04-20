ARG _WORKERBEEVERSION
ARG _PARENT
FROM gcr.io/scrna-196615/workerbee-${_PARENT}:${_WORKERBEEVERSION}

USER rstudio
WORKDIR /home/rstudio

RUN Rscript -e 'BiocManager::install(c("broom", "cobs", \
    "DrImpute", "fastICA", "fitdistrplus", "gamlss.dist", \
    "ggpubr", "Hmisc", "kernlab", "MBESS", \
    "", "mclust", "methods", "minpack.lm", "moments", "msir", \
    "NBPSeq", "nonnest2", "penalized", "pscl", "Rmagic", \
    "Rtsne", "scales", "snow", \
    "truncnorm", "VGAM", "ZIM"))' && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN Rscript -e 'BiocManager::install(c("bayNorm", "baySeq", "DEDS", \
    "EBSeq", "IHW", "iCOBRA", "Linnorm", "MAST", "monocle", "NOISeq", \
    "qvalue", "ROTS", "RUVSeq", "S4Vectors", "scater", "scDD", "scde", "scone", "scran", \
    "SCnorm", "zinbwave"))' && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN Rscript -e 'BiocManager::install(c( \
        "cz-ye/DECENT", \
        "nghiavtr/BPSC", \
        "mohuangx/SAVER", \
        "statOmics/zingeR", \
        "Vivianstats/scImpute"))'

RUN Rscript -e 'BiocManager::install(c("ggstance", "rmdformats", "knitr", "recount", "plotrix"))'
RUN Rscript -e 'BiocManager::install("bvieth/powsimR", build_vignettes = TRUE, dependencies = FALSE)'

USER root
