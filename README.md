
# Table of Contents

1.  [Preamble](#org99ca9d4)
    1.  [Plan](#org68d1c45)
        1.  [List of images planned](#orgf7455ea)
        2.  [Tasks](#org57f9833)
2.  [Notes](#org161bbc8)
    1.  [Tools and methodology](#org9db719c)
    2.  [Running these files](#org340b4f3)
    3.  [Launching the docker container](#org6aac412)
    4.  [Strategy](#orga290a3a)
    5.  [Status Log](#orgdf926dd)
3.  [Latest Libraries - Shiny and RStudio server](#org75bb2ea)
    1.  [Overview](#org684ad89)
    2.  [Dockerfile](#org616c379)
        1.  [Container run command](#orgf3cd40d)
        2.  [Userconf for rstudio](#org210710f)
        3.  [Dockerfile contents](#orge55d28b)
4.  [Experimental Containers](#org6cd2938)
5.  [Test Shiny App](#org6d6c157)
    1.  [Widget Gallery](#org0c4b9c6)
6.  [Basic Template](#org2906c27)


<a id="org99ca9d4"></a>

# Preamble

The starting point of this project was [Matt Dancho's shinyauth](https://github.com/business-science/shinyauth) docker file, which has been generally referred to as the base template in this document. The initial focus will be on R, and will slowly extend to including Python as well.

In this regard, the [Data Science School's docker image](https://hub.docker.com/r/datascienceschool/rpython) is quite useful as a comprehensive reference as well.

The goal is to develop a workflow based on Docker (and other tools) to create a reproducible, standard, consistent environment to run datascience projects, with different development and production environments.


<a id="org68d1c45"></a>

## Plan


<a id="orgf7455ea"></a>

### List of images planned

1.  Development : R based
    1.  [ ] R Shiny server - version to be specified
    2.  R studio server:latest
    3.  Tidyverse + ML + EDA packages  - version to be specified.

2.  Production for Shiny apps
    1.  R Shiny server : the same version as corresponding development image
    2.  Tidyverse + ML + EDA packages : the same versions corresponding to development image


<a id="org57f9833"></a>

### Tasks

1.  Primary

    -   [ ] provide specific versions of atleast the major components, like docker images, and meta-packages and other tools.
    -   [ ] Efficient method to update system package versions.
    -   [ ] Efficient method to update R packages painlessly.
    -   [ ] Start with a minimal OS layer, like Ubuntu or even Alpine.
    -   [ ] Create tests to ensure the docker image is working as expected. Consider techniques like Continuous Integration (CI)
    -   [ ] Add a file with the R session, package and other relevant information to be automatically generated when a container is run and printed to a file in the working directory.
    -   [ ] Create clearly distinct production and development environments
    -   [ ] Ensure streamlined connection to specific containers from Org mode source blocks.

2.  Good to have

    -   [ ] Construct my own shiny server rather than relying on an external official image.
    -   [ ] Evaluate integrating workflows using Drake,
    -


<a id="org161bbc8"></a>

# Notes

*There is also a bunch of general docker related notes and references [on my website](https://shreyas.ragavan.co/docs/docker-notes/).*


<a id="org9db719c"></a>

## Tools and methodology

I am currently creating dockerfiles via source code blocks inserted into Org mode documents. i.e a single Readme.org is where I will edit all the dockerfiles in this repository, which are then tangled into the dockerfiles automatically.

The Org mode format can be leveraged to record comments and notes about each dockerfile and setup within the readme document itself thus creating a literate environment.

Since each template is under it's own Org heading, the specific heading can even be exported as an org file which can be externally tangled into these source files without needing the installation of Emacs. This makes the possibilities rather interesting. Down the line, further optimisations will be made

Beyond this, tools like [docker-tramp](https://github.com/emacs-pe/docker-tramp.el/blob/master/README.md?utm_source=share&utm_medium=ios_app&utm_name=iossmf) can be used with Emacs to have org babel source blocks connect directly to docker instances and have the results printed in the local buffer. This enables a standard environment for development.


<a id="org340b4f3"></a>

## TODO Running these files

The following options exist:

1.  Pull the latest image from docker hub : `docker pull shrysr/datasciencer` and run the container. This will reference the [Adding All libraries to the Template](#org75bb2ea), wherein the latest versions of all the files will be used.
2.  Copy the contents of the dockerfile and paste into your docker file.
3.  Alternately, this repo can be cloned, and the dockerfile can be specified with the `f` flag for example `docker build . -f ~/temp/testdocker`


<a id="org6aac412"></a>

## Launching the docker container

These are some variations of snippets used for connecting to the container placed here for ready reference.

*Note that the local test\_app folder has to be created*

    #+/bin/bash
    docker container run -Pit -d --rm  -p 3838:3838 -p 8787:8787 \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/:/srv/shiny-server/test_app \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/log/shiny-server/:/var/log/shiny-server/ \
    shrysr/datasciencer:test


<a id="orga290a3a"></a>

## Strategy

-   Using the `:latest` tag is useful only for some some circumstances, because there seems to be no point in using docker images if specific versions of libraries and packages are not set and updated with care from time to time. However, atleast one image may be worth having referencing the latest version of all the libraries. This container could be used for a test to know compatibility with the latest libraries.
-   Dockerhub has a build feature wherein a github / bitbucket repo can be linked and each new  commit will trigger a build. A specific location can also be specified for the dockerfile, or a git branch name or tag. Though caching and etc are possible, the build time appears to be no better than local build time. However, this is certainly useful for subsequent builds with minor changes. It saves the effort required to commit a new image and push it to dockerhub.


<a id="orgdf926dd"></a>

## Status Log

> Current Status, <span class="timestamp-wrapper"><span class="timestamp">[2020-01-03 Fri]</span></span>
> This dockerfile will launch a shiny server to listen at the specified port. Some additional libraries like umap, glmnet, inspectdf, DataExplorer have been added in layers. The github repo is linked to the [image on dockerhub](https://hub.docker.com/repository/docker/shrysr/datasciencer).


<a id="org75bb2ea"></a>

# Latest Libraries - Shiny and RStudio server


<a id="org684ad89"></a>

## Overview

Base image: rocker/shinyverse

Beyond a list of OS libraries in the basic template, the following additional libraries are installed:

1.  pandoc
2.  pandoc-cite
3.  dtrx
4.  tree

R Libraries in addition to the base template grouped into general categories:

ML

1.  glmnet
2.  Umap *(Currently on a separate layer as it has a lot of dependencies and is a large install)*
3.  recipes
4.  rsample
5.  rpart.plot
6.  caret

EDA

1.  inspectdf
2.  DataExplorer
3.  janitor

Management

1.  drake
2.  binder
3.  easypackages
4.  remotes
5.  From github:  karthik/holepunch


<a id="org616c379"></a>

## Dockerfile


<a id="orgf3cd40d"></a>

### Container run command

    #/bin/bash
    docker container run -it -d --rm  -p 3838:3838 -p 8787:8787 \
    -e PASSWORD=abcd \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/:/srv/shiny-server/test_app \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/log/shiny-server/:/var/log/shiny-server/ \
    shrysr/datasciencer:test


<a id="org210710f"></a>

### Userconf for rstudio

Reference: <https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/userconf.sh>

    #!/usr/bin/with-contenv bash

    ## Set defaults for environmental variables in case they are undefined
    USER=${USER:=rstudio}
    PASSWORD=${PASSWORD:=rstudio}
    USERID=${USERID:=1000}
    GROUPID=${GROUPID:=1000}
    ROOT=${ROOT:=FALSE}
    UMASK=${UMASK:=022}

    ## Make sure RStudio inherits the full path
    echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

    bold=$(tput bold)
    normal=$(tput sgr0)


    if [[ ${DISABLE_AUTH,,} == "true" ]]
    then
    	mv /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf
    	echo "USER=$USER" >> /etc/environment
    fi



    if grep --quiet "auth-none=1" /etc/rstudio/rserver.conf
    then
    	echo "Skipping authentication as requested"
    elif [ "$PASSWORD" == "rstudio" ]
    then
        printf "\n\n"
        tput bold
        printf "\e[31mERROR\e[39m: You must set a unique PASSWORD (not 'rstudio') first! e.g. run with:\n"
        printf "docker run -e PASSWORD=\e[92m<YOUR_PASS>\e[39m -p 8787:8787 rocker/rstudio\n"
        tput sgr0
        printf "\n\n"
        exit 1
    fi

    if [ "$USERID" -lt 1000 ]
    # Probably a macOS user, https://github.com/rocker-org/rocker/issues/205
      then
        echo "$USERID is less than 1000"
        check_user_id=$(grep -F "auth-minimum-user-id" /etc/rstudio/rserver.conf)
        if [[ ! -z $check_user_id ]]
        then
          echo "minumum authorised user already exists in /etc/rstudio/rserver.conf: $check_user_id"
        else
          echo "setting minumum authorised user to 499"
          echo auth-minimum-user-id=499 >> /etc/rstudio/rserver.conf
        fi
    fi

    if [ "$USERID" -ne 1000 ]
    ## Configure user with a different USERID if requested.
      then
        echo "deleting user rstudio"
        userdel rstudio
        echo "creating new $USER with UID $USERID"
        useradd -m $USER -u $USERID
        mkdir /home/$USER
        chown -R $USER /home/$USER
        usermod -a -G staff $USER
    elif [ "$USER" != "rstudio" ]
      then
        ## cannot move home folder when it's a shared volume, have to copy and change permissions instead
        cp -r /home/rstudio /home/$USER
        ## RENAME the user
        usermod -l $USER -d /home/$USER rstudio
        groupmod -n $USER rstudio
        usermod -a -G staff $USER
        chown -R $USER:$USER /home/$USER
        echo "USER is now $USER"
    fi

    if [ "$GROUPID" -ne 1000 ]
    ## Configure the primary GID (whether rstudio or $USER) with a different GROUPID if requested.
      then
        echo "Modifying primary group $(id $USER -g -n)"
        groupmod -g $GROUPID $(id $USER -g -n)
        echo "Primary group ID is now custom_group $GROUPID"
    fi

    ## Add a password to user
    echo "$USER:$PASSWORD" | chpasswd

    # Use Env flag to know if user should be added to sudoers
    if [[ ${ROOT,,} == "true" ]]
      then
        adduser $USER sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
        echo "$USER added to sudoers"
    fi

    ## Change Umask value if desired
    if [ "$UMASK" -ne 022 ]
      then
        echo "server-set-umask=false" >> /etc/rstudio/rserver.conf
        echo "Sys.umask(mode=$UMASK)" >> /home/$USER/.Rprofile
    fi

    ## add these to the global environment so they are avialable to the RStudio user
    echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
    echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site


<a id="orge55d28b"></a>

### Dockerfile contents

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


<a id="org6cd2938"></a>

# Experimental Containers

    docker image ls

    FROM shrysr/datasciencer as base1
    FROM rocker/tidyverse
    COPY  --from=base1 * .


<a id="org6d6c157"></a>

# Test Shiny App

A bunch of apps will be included here for the purpose of quickly testing functionality of widgets and etc.


<a id="org0c4b9c6"></a>

## Widget Gallery

    library(shiny)

    ## Define UI
    ui  <- fluidPage(
      titlePanel("Basic widget exploration"),

      fluidRow(

        column(2,
               h3("buttons"),
               actionButton("action007", label ="Action"),
               br(),
               br(),
               submitButton("Submit")
               ),
        column(2,
               h3("Single Checkbox"),
               checkboxInput("checkbox", "Choice A", value = T)
               ),
        column(3,
               checkboxGroupInput("checkGroup",
                                  h3("checkbox group"),
                                  choices = list("Choice 1" = 1,
                                                 "Choice 2" = 2,
                                                 "Choice 3" = 3
                                                 ),
                                  selected = 1
                                  )
               ),
        column(2,
               dateInput("date",
                         h3("date input"),
                         value = ""
                         )
               )

      ),
      ## Inserting another fluid row element
      fluidRow(

        column(2,
               radioButtons("radio",
                            h3("Radio Buttons"),
                            choices = list("choice 1" = 1,
                                           "choice 2" = 2,
                                           "Radio 3"  = 3
                                           ),
                            selected =1
                            )
               ),

        column(2,
               selectInput("select",
                           h3("Select box"),
                           choices = list("choice 1" = 1,
                                          "choice 2" = 2,
                                          "choice 3" = 3
                                          ),
                           selected = 1
                           )
               ),
        column(2,
               sliderInput("slider1",
                           h3("Sliders"),
                           min = 0,
                           max = 100,
                           value = 50
                           ),

               sliderInput("slider2",
                           h3("Another Slider"),
                           min = 50,
                           max = 200,
                           value = c(60,80)
                           )
               ),
        column(2,
               selectInput("selectbox1",
                         h3("select from drop down box"),
                         choices = list("choice 1" = 22,
                                        "choice 2" = 2,
                                        "choice fake 3" = 33
                                        ),
                         selected = ""
                         )
               )

      ),
      fluidRow(
        column(3,
               dateRangeInput("daterange",
                              h3("Date range input")
                              )
               ),

        column(3,
               fileInput("fileinput",
                         h3("Select File")
                         )
               ),

        column(3,
               numericInput("numinput",
                            h3("Enter numeric value"),
                            value = 10
                            )
               ),
        column(3,
               h3("help text"),
               helpText("Hello this is line one.",
                        "This is line 2..\n",
                        "This is line 3."
                        )
               )
      )
    )


    ## Define server logic

    server <- function(input, output){


    }



    ## Run the app
    shinyApp(ui = ui, server = server)


<a id="org2906c27"></a>

# Basic Template

Matt Dancho's template as of <span class="timestamp-wrapper"><span class="timestamp">[2020-01-02 Thu]</span></span>, placed here for ready reference.

    FROM rocker/shiny-verse:latest

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
        && install2.r --error --deps TRUE \
            shinyWidgets \
            shinythemes \
            shinyjs \
            mongolite \
            jsonlite \
            config \
            remotes \
            tidyquant \
            plotly \
        && installGithub.r business-science/shinyauthr
