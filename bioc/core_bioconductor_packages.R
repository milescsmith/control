# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
options(
    repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/latest"),
    BioC_mirror = "https://packagemanager.rstudio.com/bioconductor"
    )
    
BiocManager::install(
    c(
        "BiocNeighbors",
        "DESeq2",
        "details",
        "e1071",
        "edgeR",
        "heddlr",
        "leiden",
        "limma",
        "pbdZMQ",
        "quarto",
        "rsvd",
        "rtracklayer",
        "Rtsne",
        "SummarizedExperiment",
        "targets",
        "tximport",
        "tximeta",
        "uwot",
        "visdat",
        "visNetwork",
        "WGCNA",
        "workflowr",
        "ReactomePA",
        "ggnewscale",
        "enrichplot",
        "msigdb"
    ),
    upgrade        = FALSE,
    ask            = FALSE,
    checkBuilt     = TRUE,
    verbose        = TRUE,
    quiet          = TRUE,
    configure.vars = "--silent",
    configure.args =  "--clean"
)

BiocManager::install("milescsmith/moduleScoreR")
BiocManager::install("milescsmith/parallelCluster")
BiocManager::install("milescsmith/ggforce")
