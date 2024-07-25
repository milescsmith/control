BiocManager::install(
    c(
        "ape",
        "BaderLab/scClustViz",
        "celldex",
        "chris-mcginnis-ucsf/MULTI-seq",
        "glmGamPoi",
        "ShortRead",
        "tarchetypes",
        "tidyHeatmap"
    ),
    upgrade = TRUE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = FALSE,
    configure.args = "--clean",
    clean = TRUE
)
