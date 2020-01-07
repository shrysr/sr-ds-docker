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
	libzmq3-dev \
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

# Installing libraries for ML
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
	easypackages \
	remotes \
	&& installGithub.r karthik/holepunch

# Adding Rstudio server preview version as an environment variable which can be changed.
# Reference: https://github.com/datascienceschool/docker_rpython/blob/0c01b0b52834f6b3bb8a0c930a3d43899ea60ce6/02_rpython/Dockerfile#L17

USER root
ENV RSTUDIOSERVER_VERSION 1.2.5036
ENV RSTUDIO_SERVER_ON ON
RUN \
apt-get update \
&& apt-get install psmisc \
&& mkdir -p /download && cd /download \
&& wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb \
&& gdebi --n rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb \
&& rm -rf /download \
&& rm -rf /var/lib/apt \
&& apt-get autoclean
#$$ if {$RSTUDIO_SERVER_ON}
# Settings for RStudio-Server

EXPOSE 8787
RUN rstudio-server start
