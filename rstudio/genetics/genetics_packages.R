# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.

BiocManager::install(
    c(
        'minfi',
        'IlluminaHumanMethylationEPICanno.ilm10b2.hg19',
        'missMethyl',
        'minfiData',
        'CpGassoc'
    ),
    upgrade = FALSE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = FALSE,
    configure.args = '--clean',
    clean = TRUE
    # configure.vars = "--silent"
)
