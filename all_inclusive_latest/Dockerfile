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

# Temp layer to be integrated into OS package layer
RUN apt-get update \
&& apt-get -y --no-install-recommends install git

# Adding Rstudio server preview version as an environment variable which can be changed.
# Reference: https://github.com/datascienceschool/docker_rpython/blob/0c01b0b52834f6b3bb8a0c930a3d43899ea60ce6/02_rpython/Dockerfile#L17

USER root
ARG PANDOC_TEMPLATES_VERSION
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV PANDOC_TEMPLATES_VERSION=${PANDOC_TEMPLATES_VERSION:-2.9}

ENV RSTUDIOSERVER_VERSION 1.2.5036
ENV RSTUDIO_PREVIEW YES
RUN \
apt-get update \
&& apt-get install psmisc \
&& mkdir -p /download && cd /download \
&& wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb \
# && gdebi --n rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb \
# && rm -rf /download \
# && rm -rf /var/lib/apt \
# && apt-get autoclean \
# && rstudio-server start

#$$ if {$RSTUDIO_SERVER_ON}
# Settings for RStudio-Server
# && if [ -z "$RSTUDIO_PREVIEW" ]; \
# 	then RSTUDIO_URL="https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb"; \
# 	else RSTUDIO_URL="https://www.rstudio.org/download/latest/stable/server/bionic/rstudio-server-latest-amd64.deb"; fi \
  # && wget -q $RSTUDIO_URL \
	&& gdebi --n rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb \
##  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Need to configure non-root user for RStudio
  && useradd rstudio \
  && echo "rstudio:rstudio" | chpasswd \
	&& mkdir /home/rstudio \
	&& chown rstudio:rstudio /home/rstudio \
	&& addgroup rstudio staff \
  ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
  &&  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  ## configure git not to request password each time
  && git config --system credential.helper 'cache --timeout=3600' \
  && git config --system push.default simple \
  # ## Set up S6 init system
  # && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
  # && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
          \n## load /etc/environment vars first: \
  		  \n for line in $( cat /etc/environment ) ; do export $line ; done \
          \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/services.d/rstudio/run \
  && echo '#!/bin/bash \
          \n rstudio-server stop' \
          > /etc/services.d/rstudio/finish \
  && mkdir -p /home/rstudio/.rstudio/monitored/user-settings \
  && echo 'alwaysSaveHistory="0" \
          \nloadRData="0" \
          \nsaveAction="0"' \
          > /home/rstudio/.rstudio/monitored/user-settings/user-settings \
  && chown -R rstudio:rstudio /home/rstudio/.rstudio \
	&& rstudio-server start

COPY userconf.sh /etc/cont-init.d/userconf

EXPOSE 8787
