setRepositories(ind=1:3)
BiocManager::install(
    c(
        "Seurat",
        "seurat-data",
        "seurat-wrappers",
        "seurat-disk",
        "Signac",
        "BSgenome.Hsapiens.UCSC.hg38",
        "EnsDb.Hsapiens.v86"
    ),
    upgrade = "always",
    build_manual = FALSE,
    dependencies = TRUE,
    configure.args = "--clean",
    clean = TRUE
    )