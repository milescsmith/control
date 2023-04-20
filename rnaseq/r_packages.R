# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
install.packages('hdf5r', configure.args='--with-hdf5=/usr/bin/h5cc', clean = TRUE)

BiocManager::install(
    c(
      	"DescTools",
        "factoextra",
        "flextable",
        "fpc",
        "HGNChelper",
        "hgu95av2.db",
        "illuminaHumanv4.db",
        "lumi",
        "lumiHumanAll.db",
        "lumiHumanIDMapping",
	"parallelly",
        "PCAtools",
	"pheatmap",
	"quarto",
        "statmod",
        "styler",
        "sva",
        "tarchetypes",
        "tidyHeatmap",
        "tidyxl",
        "vip"
    ),
    upgrade = FALSE,
    ask = FALSE,
    checkBuilt = TRUE,
    verbose = TRUE,
    quiet = TRUE,
    configure.vars = "--silent",
    configure.args = "--clean"
)

BiocManager::install("ricardo-bion/ggradar")
