FROM rocker/shiny-verse:latest

LABEL maintainer="Shreyas Ragavan <sr@eml.cc>" \
	version="1.0"

# System update
RUN apt-get update -qq

# Installing a bunch of packages for the OS
RUN apt-get -y --no-install-recommends install \
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
        pandoc \
        pandoc-citeproc

# Installing some minimum R libraries for shiny
RUN install2.r --error --deps TRUE \
	shinyWidgets \
        shinythemes \
        shinyjs

# Intalling DB drivers
RUN install2.r --error --deps TRUE \
	mongolite \
        jsonlite \
        config

# Tidyquant and Remotes
RUN install2.r --error --deps TRUE \
	remotes \
	tidyquant

# Installing plotly
RUN install2.r --error --deps TRUE \
	plotly

# Separating Umap to a separate layer to save time while building the image
RUN install2.r --error --deps TRUE \
	umap

# Installing a bunch of libraries for EDA, Linear Regression with GLMnet
RUN install2.r --error --deps TRUE \
    	inspectdf \
	DataExplorer \
	glmnet

#    && installGithub.r shrysr/sr-ds-docker/all_inclusive_latest
