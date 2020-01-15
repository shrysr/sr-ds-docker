#Script for common package installation on MatrixDS docker image
PKGS <- c(
     "tidyverse", "mapproj", "maps"
)

install.packages(PKGS, dependencies = TRUE)
