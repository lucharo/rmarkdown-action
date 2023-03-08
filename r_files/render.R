args = commandArgs(trailingOnly = TRUE)
library(rmarkdown)
render(args[1], output_format = args[2])
