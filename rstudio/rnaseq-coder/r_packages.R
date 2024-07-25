# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
install.packages('hdf5r', configure.args='--with-hdf5=/usr/bin/h5cc', clean = TRUE)

BiocManager::install(
    c(
        "EnhancedVolcano",
        "milescsmith/enrichplot",
        "PCAtools",
        "fpc",
	"glmGamPoi",
        "ReactomePA",
        "keras",
        "milescsmith/moduleScoreR@2.0.1",
        "rpart.plot",
        "statmod",
        "ggnewscale"
    ),
    upgrade = FALSE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = TRUE,
    configure.vars = "--silent",
    configure.args = "--clean"
)
