#Script for common package installation on MatrixDS docker image
PKGS <- c(
      "tidyverse", "mapproj", "maps", "genius", "shinycssloaders", "gmailr"
)

install.packages(PKGS, dependencies = TRUE)

# These packages are sometimes not available for the current R version
# , and therefore installed directly from github
devtools::install_github("tidyverse/googlesheets4", dependencies = TRUE)
devtools::install_github("tidyverse/googletrendsR", dependencies = TRUE)
