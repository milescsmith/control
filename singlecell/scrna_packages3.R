remotes::install_github(
    c(
        "immunogenomics/presto",
        "milescsmith/enhancedDimPlot",
        "milescsmith/ReductionWrappers",
        "milescsmith/s2a",
        "milescsmith/SeuratBubblePlot",
        "milescsmith/SeuratPlotly",
        "milescsmith/ViolinEnsemble"
    ),
    upgrade = "always",
    dependencies = TRUE,
    build_manual = FALSE
)