# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
install.packages('BiocManager')
install.packages("remotes")
install.packages('hdf5r', configure.args='--with-hdf5=/usr/bin/h5cc', clean = TRUE)

BiocManager::install()
BiocManager::install(
    c(
        "future",
        "future.apply",
        "furrr",
        "future.batchtools"
    ),
    upgrade = FALSE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = TRUE,
    configure.vars = "--silent",
    configure.args = "--clean"
)