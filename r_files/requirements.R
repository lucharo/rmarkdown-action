#copied from: https://github.com/kenf1/KScripts/blob/main/R/R_pkg_install.R

#--- KF's script for quick beginner R setup ---#

## From CRAN

#required packages
req_pkg <- c(
  "readxl",
  "rmarkdown",
  "knitr",
  "devtools"
)

#install required packages
install.packages(req_pkg)

## From GitHub

#KF.QoL (custom function & Rmd templates)
# devtools::install_github("kenf1/KF.QoL")

#clean up environment & memory
rm(req_pkg)
gc()