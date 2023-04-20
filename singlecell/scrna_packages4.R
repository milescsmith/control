BiocManager::install(
    c(
        "DropletUtils",
        "sctransform",
        "schex",
        "SingleR"
    ),
    upgrade = TRUE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = FALSE,
    configure.args = "--clean",
    clean = TRUE
)
