source("~/.Rprofile")
options(
    repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/latest"),
    BioC_mirror = "https://packagemanager.rstudio.com/bioconductor"
    )
install.packages(
    'BiocManager',
     lib = "~/R/x86_64-pc-linux-gnu-library"
     )
BiocManager::install(
    version = "3.17",
    update = TRUE,
    ask = FALSE
    )
BiocManager::install(
    c(
        "reticulate",
        'IRkernel',
        'tidyverse'
    ),
    upgrade        = FALSE,
    ask            = FALSE,
    checkBuilt     = TRUE,
    verbose        = TRUE,
    quiet          = TRUE,
    configure.vars = "--silent",
    configure.args =  "--clean"
)