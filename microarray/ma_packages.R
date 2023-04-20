# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.

BiocManager::install(
    c(
        "lumi",
        "lumiHumanIDMapping",
        "beadarray",
        "affy",
        "oligo",
        "illuminaHumanv4.db",
        "hgu95av2.db",
        "lumiHumanAll.db"
    ),
    upgrade        = FALSE,
    ask            = FALSE,
    checkBuilt     = TRUE,
    verbose        = TRUE,
    quiet          = FALSE,
    configure.args = "--clean",
    clean          = TRUE
)
