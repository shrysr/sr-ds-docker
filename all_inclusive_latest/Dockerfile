FROM rocker/shiny-verse:latest

LABEL maintainer="Shreyas Ragavan <sr@eml.cc>" \
	version="1.0"

# System update and installing a bunch of OS libraries
RUN apt-get update -qq \
	&& apt-get -y --no-install-recommends install \
	lbzip2 \
	libfftw3-dev \
        libgdal-dev \
        libgeos-dev \
        libgsl0-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libhdf4-alt-dev \
        libhdf5-dev \
        libjq-dev \
        liblwgeom-dev \
        libpq-dev \
        libproj-dev \
        libprotobuf-dev \
        libnetcdf-dev \
        libsqlite3-dev \
        libssl-dev \
        libudunits2-dev \
        netcdf-bin \
        postgis \
        protobuf-compiler \
        sqlite3 \
        tk-dev \
        unixodbc-dev \
        libsasl2-dev \
        libv8-dev \
	libsodium-dev \
# Adding a custom list of packages from this point
        pandoc \
	pandoc-citeproc \
	dtrx \
	tree \
# Removing temporary files generated after package changes
	&& rm -rf /var/lib/apt \
	&& apt-get autoclean

# Installing minimum R libraries for shiny
RUN install2.r --error --deps TRUE \
	shinyWidgets \
        shinythemes \
        shinyjs

# Intalling DB interfacing libraries
RUN install2.r --error --deps TRUE \
	mongolite \
        jsonlite \
        config

# Tidyquant and Remotes
RUN install2.r --error --deps TRUE \
	tidyquant

# Installing plotly
RUN install2.r --error --deps TRUE \
	plotly

# Separating Umap to a separate layer to save time while building the image
RUN install2.r --error --deps TRUE \
	umap

# Installing libraries for EDA
RUN install2.r --error --deps TRUE \
    	inspectdf \
	DataExplorer \
	janitor

# Installing libraries for  Linear Regression with GLMnet
RUN install2.r --error --deps TRUE \
	glmnet \
	parsnip \
	recipes \
	rsample \
	rpart.plot \
	caret

# Installing libraries related to reproducibility DevOps, planning, package management
RUN install2.r --error --deps TRUE \
	drake \
	binder \
	easypackages \
	remotes \
	&& installGithub.r karthik/holepunch
