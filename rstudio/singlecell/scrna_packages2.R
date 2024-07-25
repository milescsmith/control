BiocManager::install(
    c(
        "satijalab/Seurat",
        "satijalab/seurat-data",
        "satijalab/seurat-wrappers",
        "mojaveazure/seurat-disk"
    ),
    upgrade = "always",
    build_manual = FALSE,
    dependencies = TRUE,
    configure.args = "--clean",
    clean = TRUE
    )