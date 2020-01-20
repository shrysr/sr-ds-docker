#Script for common package installation on MatrixDS docker image
PKGS <- c(
      "tidyverse", "mapproj", "maps", "genius"
)

install.packages(PKGS, dependencies = TRUE)
devtools::install_github("tidyverse/googlesheets4", dependencies = TRUE)
devtools::install_github("tidyverse/googletrendsR", dependencies = TRUE)
