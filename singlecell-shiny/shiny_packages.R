# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
BiocManager::install(
    c(
        "flexdashboard",
        "shiny"
    ), upgrade = FALSE,
    ask = FALSE,
    checkBuilt = TRUE, quiet = TRUE, configure.vars = "--silent"
)