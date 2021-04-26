# folgender Vektor enthaelt alle Pakete, die keine Abhaengigkeit von R-tidyverse sind, die für den iGOEGGO benoetigt werden.
requirements <- c(
    "sortable",
    "shinydashboard",
    "gridExtra",
    "plotly",
    "shinyjs",
    "shinycssloaders",
    "hash",
    "shinybusy",
    "shinyalert",
    "shinytest",
    "RSQLite",
    "urltools",
    "psych"
)
install.packages(requirements, lib = "/usr/local/lib/R/site-library")
# i18n wird fuer Spracheinstellungen benoetigt
require(devtools)
devtools::install_github("Appsilon/shiny.i18n")
