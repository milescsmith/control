BiocManager::install(
    c(
        # "ape",
        # "chris-mcginnis-ucsf/MULTI-seq",
        "glmGamPoi",
        "tarchetypes",
        "tidyHeatmap",
        "factoextra",
        "flextable",
        # "fpc",
        # "HGNChelper",
        # "pheatmap",
        # "quarto",
        "tarchetypes",
        "tidyHeatmap",
        "tidyxl",
        "vip"
    ),
    upgrade = TRUE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = FALSE,
    configure.args = "--clean",
    clean = TRUE
)
