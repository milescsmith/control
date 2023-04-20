# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
BiocManager::install(
    c(
        "batchools",
        "future.batchools"
    ),
    upgrade = TRUE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = FALSE,
    configure.args = "--clean",
    clean = TRUE
)