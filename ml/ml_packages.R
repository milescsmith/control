# Need to keep the packages in alphabetical order so we don't duplicate anything
# pak::pkg_install will fail if we do.
BiocManager::install(
    c(
        "BH",
        "DataExplorer",
        "glmnet",
        "mice",
        "mlr3verse",
        "nnet",
        "randomForest",
        "ranger",
        "rpart",
        "rstan",
        "superml",
        "tidymodels",
        "xgboost"
    ),
    upgrade = FALSE,
    ask = FALSE,
    checkBuilt = TRUE,
    quiet = TRUE
)

devtools::install_github('catboost/catboost', subdir = 'catboost/R-package')