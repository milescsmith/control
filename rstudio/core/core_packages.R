# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
install.packages(
    'hdf5r',
    configure.args = '--with-hdf5=/usr/bin/h5cc'
    )

install.packages(
    c(
        "batchools",
        "cowplot",
        "devtools",
        "EnhancedVolcano",
        "fdrtool",
        "formattable",
        "furrr",
        "future.batchools",
        "future.callr",
        "ggbeeswarm",
        "crotoc/ggforce",
        "fastverse",
        "ggpubr",
        "ggtext",
        "gtools",
        "here",
        "inspectdf",
        "irlba",
        "janitor",
        "kableExtra",
        "librarian",
        "oaColors",
        "paletteer",
        "parallelDist",
        "tidyHeatmap",
        "plotly",
        "ragg",
        "Rcpp",
        "RcppArmadillo",
        "RcppEigen",
        "reticulate",
        "Rfast",
        "Rfast2",
        "rsvd",
        "R.utils",
        "tidyverse",
        "tinytex",
        "usethis"
    ),
    upgrade        = TRUE,
    ask            = FALSE,
    checkBuilt     = TRUE,
    verbose        = FALSE,
    quiet          = TRUE,
    configure.vars = "--silent",
    configure.args = "--clean",
    repos = "https://packagemanager.rstudio.com/all/latest"
)

devtools::install_github("teunbrand/ggh4x")
