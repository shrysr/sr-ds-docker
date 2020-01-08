
# Table of Contents

1.  [Preamble](#orgd306405)
    1.  [Plan](#org9c4d2d7)
        1.  [List of images planned](#org9fcb07d)
        2.  [Tasks](#orgd27bdee)
2.  [Notes](#org72c6f09)
    1.  [Tools and methodology](#orgdfcaf2f)
    2.  [Running these files](#org63cc898)
    3.  [Launching the docker container](#orgb58c268)
    4.  [Status Log](#org9a683b3)
    5.  [General Notes](#org7328acb)
3.  [A Smith](#org7e2c9fe)
4.  [rbase](#orgd9df02d)
    1.  [R package list](#org2115563)
    2.  [Dockerfile](#org85a05ba)
5.  [Rstudio](#orgc442316)
    1.  [Environment and Profile](#org487bee4)
    2.  [Add shiny](#org09a252d)
    3.  [Encrypted sign in](#org9c660b6)
    4.  [Entrypoint](#org8979aa1)
    5.  [nginx conf](#org2d71656)
    6.  [Additional Packages](#org2317d66)
    7.  [PAM helper](#orgdceedad)
    8.  [User settings](#org28c7ea8)
    9.  [Userconf](#orgee8bdf1)
    10. [Dockerfile](#orgbe4a639)
    11. [Container launch](#orge43befb)
6.  [Shiny](#orgf86cb5b)
    1.  [Environment and Profile](#orgf991fe5)
    2.  [app.r](#org6218abf)
    3.  [entrypoint](#orgd9fcec2)
    4.  [shiny server script](#org4e8b98b)
    5.  [packages](#org1dc5ae3)
    6.  [version](#org8988f5f)
    7.  [Dockerfile](#orgce85ca7)
    8.  [Container launch](#org719bf03)
7.  [Rstudio Server Preview](#org6f1b9a6)
8.  [Latest Libraries - Shiny and RStudio server](#org38180fa)
    1.  [Overview](#orgcbbe7eb)
    2.  [Dockerfile](#org8b415d0)
        1.  [Container run command](#org749f01b)
        2.  [Userconf for rstudio](#orge4c14c3)
        3.  [Dockerfile contents](#org318e6d4)
9.  [Test Shiny App](#org9a326c1)
    1.  [Widget Gallery](#org0378943)
10. [Experimental Containers](#orgcd05b3f)
11. [Basic Template](#org1230e96)



<a id="orgd306405"></a>

# Preamble

The starting point of this project was [Matt Dancho's shinyauth](https://github.com/business-science/shinyauth) docker file, which then expanded into using the well designed [Matrix DS tools](https://github.com/matrixds/tools) for my purpose. Their docker stack of tools is replicated here with my customization.

The goal is to develop a workflow based on Docker (and other tools) to create a reproducible, standard, consistent environment to run a variety of datascience projects, with different development and production environments. In particular, I want to be able to develop and deploy dashboards like shiny or streamlit.io quickly and with ease.

> Why not just use the MatrixDS stack directly and add the missing packages as layers?
>
> Fair question and quite possible. It may seem childish, but I wanted to build these images by hand as my set of tools, even if the tools were largely similar to the MatrixDS stack. From whatever I've learned of Docker - the MatrixDS stack is quite efficient and the cascading + common dependency layer makes sense to use. There may be other methods, but this certainly appeared technically sensible.

These containers are hosted on dockerhub as :

1.  [shrysr/asmith](https://hub.docker.com/repository/docker/shrysr/asmith)
2.  [shrysr/rbase](https://hub.docker.com/repository/docker/shrysr/rbase)
3.  [shrysr/rstudio](https://hub.docker.com/repository/docker/shrysr/rstudio)
4.  [shrysr/shiny](https://hub.docker.com/repository/docker/shrysr/shiny)

One of the earlier versions created is at shrysr/datasciencer


<a id="org9c4d2d7"></a>

## TODO Plan


<a id="org9fcb07d"></a>

### TODO List of images planned

1.  Development : R based
    1.  R Shiny server - version to be specified
    2.  R studio server:latest
    3.  Tidyverse + ML + EDA packages  - version to be specified.

2.  Production for Shiny apps
    1.  R Shiny server : the same version as corresponding development image
    2.  Tidyverse + ML + EDA packages : the same versions corresponding to development image


<a id="orgd27bdee"></a>

### TODO Tasks

1.  Primary <code>[3/8]</code>

    -   [ ] provide specific versions of atleast the major components, like docker images, and meta-packages and other tools.
    -   [X] Efficient method to update system package versions.
    -   [X] Efficient method to update R packages painlessly.
    -   [X] Start with a minimal OS layer, like Ubuntu or even Alpine.
    -   [ ] Create tests to ensure the docker image is working as expected. Consider techniques like Continuous Integration (CI)
    -   [ ] Add a file with the R session, package and other relevant information to be automatically generated when a container is run and printed to a file in the working directory.
    -   [ ] Create clearly distinct production and development environments
    -   [ ] Ensure streamlined connection to specific containers from Org mode source blocks.

2.  Good to have <code>[0/2]</code>

    -   [ ] Construct my own shiny server rather than relying on an external official image.
    -   [ ] Evaluate integrating workflows using Drake,


<a id="org72c6f09"></a>

# Notes

*There is also a bunch of general docker related notes and references [on my website](https://shreyas.ragavan.co/docs/docker-notes/).*


<a id="orgdfcaf2f"></a>

## Tools and methodology

I am currently creating dockerfiles via source code blocks inserted into Org mode documents. i.e a single Readme.org is where I will edit all the dockerfiles in this repository, which are then tangled into the dockerfiles automatically.

The Org mode format can be leveraged to record comments and notes about each dockerfile and setup within the readme document itself thus creating a literate environment.

Since each template is under it's own Org heading, the specific heading can even be exported as an org file which can be externally tangled into these source files without needing the installation of Emacs. This makes the possibilities rather interesting. Down the line, further optimisations will be made

Beyond this, tools like [docker-tramp](https://github.com/emacs-pe/docker-tramp.el/blob/master/README.md?utm_source=share&utm_medium=ios_app&utm_name=iossmf) can be used with Emacs to have org babel source blocks connect directly to docker instances and have the results printed in the local buffer. This enables a standard environment for development.


<a id="org63cc898"></a>

## TODO Running these files

The following options exist:

1.  Pull the latest image from docker hub : `docker pull shrysr/datasciencer` and run the container. This will reference the [Adding All libraries to the Template](#org38180fa), wherein the latest versions of all the files will be used.
2.  Copy the contents of the dockerfile and paste into your docker file.
3.  Alternately, this repo can be cloned, and the dockerfile can be specified with the `f` flag for example `docker build . -f ~/temp/testdocker`


<a id="orgb58c268"></a>

## Launching the docker container

These are some variations of snippets used for connecting to the container placed here for ready reference. Individual snippets are placed along with the documentation of each docker container, and will be incorporated into the readme's eventually.

-   [ ] incorporate the container launch instructions into individual docker repo readme.

*Note that the local test\_app folder has to be created*

    #+/bin/bash
    docker container run -Pit -d --rm  -p 3838:3838 -p 8787:8787 \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/:/srv/shiny-server/test_app \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/log/shiny-server/:/var/log/shiny-server/ \
    shrysr/datasciencer:test


<a id="org9a683b3"></a>

## Status Log

> -   <span class="timestamp-wrapper"><span class="timestamp">[2020-01-08 Wed] </span></span> : Basic MatrixDS tools have been replicated like the Asmith, rbase and shiny layers. Relatively minor package additions have been made to the asmith and rbase layers. The Rstudio layer still needs some work.

-   <span class="timestamp-wrapper"><span class="timestamp">[2020-01-07 Tue] </span></span> : Further efforts will be based off the Matrix DS images. Essentially, there will be a r-base image with all the package installations which will feed the other tools and containers. This ensures that all the containers rely on the same dependencies. Subsequently, only the mountpoint becomes important. This approach is better because it enables smaller containers with single critical processes rather than multiple processes.

-   <span class="timestamp-wrapper"><span class="timestamp">[2020-01-03 Fri] </span></span> : This dockerfile will launch a shiny server to listen at the specified port. Some additional libraries like umap, glmnet, inspectdf, DataExplorer have been added in layers. The github repo is linked to the [image on dockerhub](https://hub.docker.com/repository/docker/shrysr/datasciencer).


<a id="org7328acb"></a>

## General Notes

-   Using the `:latest` tag is useful only for some some circumstances, because there seems to be no point in using docker images if specific versions of libraries and packages are not set and updated with care from time to time. However, atleast one image may be worth having referencing the latest version of all the libraries. This container could be used for a test to know compatibility with the latest libraries.

-   Dockerhub has a build feature wherein a github / bitbucket repo can be linked and each new  commit will trigger a build. A specific location can also be specified for the dockerfile, or a git branch name or tag. Though caching and etc are possible, the build time appears to be no better than local build time. However, this is certainly useful for subsequent builds with minor changes. It saves the effort required to commit a new image and push it to dockerhub.

-   the [Data Science School's docker image](https://hub.docker.com/r/datascienceschool/rpython) is useful as a comprehensive reference.


<a id="org7e2c9fe"></a>

# A Smith

This is the very first layer. This layer adds several OS packages and starts with a specific version of Ubuntu (v18.04). Currently, it is largely left the same except for adding the package dtrx, which is useful to quickly zip and unzip files.

This layer does not take very long to build, however, if it is - then all the other subsequent layers will probably need to be rebuilt.

    FROM ubuntu:18.04

    USER root

    ENV DEBIAN_FRONTEND noninteractive

    RUN apt-get update

    # Install all basic OS dependencies
    RUN apt-get update \
      && apt-get install -yq --no-install-recommends \
        apt \
        apt-utils \
        bash-completion \
        build-essential \
        byacc \
        bzip2 \
        ca-certificates \
        emacs \
        file \
        flex \
        fonts-dejavu \
        fonts-liberation \
        fonts-texgyre \
        g++ \
        gcc \
        gettext \
        gfortran \
        git \
        gnupg2 \
        gsfonts \
        hdf5-tools \
        icu-devtools \
        jed \
        lmodern \
        locales \
        make \
        mesa-common-dev \
        nano \
        netcat \
        openjdk-8-jdk \
        pandoc \
        software-properties-common \
        sudo \
        texlive-fonts-extra \
        texlive-fonts-recommended \
        texlive-generic-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-xetex \
        tzdata \
        unzip \
        vim \
        wget \
        zip \
      && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
      && locale-gen en_US.utf8 \
      && /usr/sbin/update-locale LANG=en_US.UTF-8

    # make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
    ENV LANG=en_US.utf8 \
        LC_ALL=en_US.UTF-8 \
        TERM=xterm \
        APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

    # Install additional libraries
    RUN apt-get install -yq --no-install-recommends \
        libblas-dev \
        libcurl4 \
        libcurl4-gnutls-dev \
        libgdal-dev \
        libglu1-mesa-dev \
        libgmp3-dev \
        libicu60 \
        libjpeg-turbo8 \
        libmagick++-dev \
        libmariadb-client-lgpl-dev \
        libmpfr-dev \
        libmpfr-dev \
        libncurses5-dev \
        libnettle6 \
        libnlopt-dev \
        libopenblas-dev \
        libpango1.0-0 \
        libpangocairo-1.0-0 \
        libpng16-16 \
        libpq-dev \
        libsasl2-dev \
        libsm6 \
        libssl-dev \
        libtiff5 \
        libtool \
        libudunits2-dev \
        libxext-dev \
        libxml2-dev \
        libxrender1 \
        zlib1g-dev \
    	dtrx

    # Set timezone noninteractively
    RUN ln -fs /usr/share/zoneinfo/US/Pacific /etc/localtime

    # Python stuff
    RUN apt-get install -y --no-install-recommends \
        python-pip \
        python-setuptools \
        python-wheel \
        python-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        python3-dev \
      && apt-get clean

    #install git, vim

    RUN apt-get install -y git \
    	                   vim \
                           curl

    #install kaggle cli
    RUN pip install kaggle dvc tensorflow keras pandas

    #mongo cli
    RUN apt-get install -y mongodb-clients

    #mysql shell
    RUN apt-get install -y mysql-client

    #postgre shell
    RUN apt-get install -y postgresql-client

    # Add Tini
    ENV TINI_VERSION v0.18.0
    ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
    RUN chmod +x /tini
    ENTRYPOINT ["/tini", "--"]

    RUN apt-get clean \
      && rm -rf /var/lib/apt/lists/*


<a id="orgd9df02d"></a>

# rbase

This layer contains all the basic R packages required for datascience and ML. A bunch of packages were added to the already extensive default list of packages in MatrixDS's docker file.

The packages are defined in an R script called packages.R.

This layer takes a *tremendously long time to build*. A couple of hours on a Macbook Pro 2019, with 6 cores and 32 GB of RAM. One should be careful in assessing whether this layer has to be disturbed. Automated builds on Dockerhub are likely to take even longer.

Note: As such the dockerfile indicates that the packages are called in the last 2 layers only. It may be possible that subsequent image builds do not take as much time as I imagine.

-   [ ] It may be easier to find a way to keep the additional packages specified in the rstudio and shiny package list to be in sync.


<a id="org2115563"></a>

## R package list

    #Script for common package installation on MatrixDS docker image
    p<-c('nnet','kknn','randomForest','xgboost','tidyverse','plotly','shiny','shinydashboard',
    	  'devtools','FinCal','googleVis','DT', 'kernlab','earth',
         'htmlwidgets','rmarkdown','lubridate','leaflet','sparklyr','magrittr','openxlsx',
         'packrat','roxygen2','knitr','readr','readxl','stringr','broom','feather',
         'forcats','testthat','plumber','RCurl','rvest','mailR','nlme','foreign','lattice',
         'expm','Matrix','flexdashboard','caret','mlbench','plotROC','RJDBC','rgdal',
         'highcharter','tidyquant','timetk','quantmod','PerformanceAnalytics','scales',
         'tidymodels','C50', 'parsnip','rmetalog','reticulate','umap', 'glmnet', 'easypackages', 'drake', 'shinythemes', 'shinyjs', 'recipes', 'rsample', 'rpart.plot', 'remotes', 'DataExplorer', 'inspectdf', 'janitor', 'mongolite', 'jsonlite', 'config' )


    install.packages(p,dependencies = TRUE)


<a id="org85a05ba"></a>

## Dockerfile

    FROM shrysr/asmith:v1

    #install some helper python packages
    RUN pip install sympy numpy

    # R Repo, see https://cran.r-project.org/bin/linux/ubuntu/README.html
    RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' >> /etc/apt/sources.list
    RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
    RUN add-apt-repository ppa:marutter/c2d4u3.5

    # R-specific packages
    RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        r-base \
        r-base-core \
        r-recommended \
        r-base-dev \
        r-cran-boot \
        r-cran-class \
        r-cran-cluster \
        r-cran-codetools \
        r-cran-foreign \
        r-cran-kernsmooth \
        r-cran-matrix \
        r-cran-rjava \
        r-cran-rpart \
        r-cran-spatial \
        r-cran-survival
    COPY r_packages.R .
    RUN R CMD javareconf \
      && Rscript r_packages.R \
      && rm r_packages.R


    COPY packages.R /usr/local/lib/R/packages.R

    #install R packages
    RUN R CMD javareconf && \
        Rscript /usr/local/lib/R/packages.R


<a id="orgc442316"></a>

# Rstudio

This layer contains a specified RStudio version built on top of the rbase layer. i.e all the R packages defined in the earlier layers will be available to this web based deployment of Rstudio server.


<a id="org487bee4"></a>

## Environment and Profile

    R_LIBS=/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library:/home/rstudio/.R/library

    .libPaths("/home/rstudio/.R/library")


<a id="org09a252d"></a>

## Add shiny

    #!/usr/bin/with-contenv bash

    ADD=${ADD:=none}

    ## A script to add shiny to an rstudio-based rocker image.

    if [ "$ADD" == "shiny" ]; then
      echo "Adding shiny server to container..."
      apt-get update && apt-get -y install \
        gdebi-core \
        libxt-dev && \
        wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
        VERSION=$(cat version.txt)  && \
        wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
        gdebi -n ss-latest.deb && \
        rm -f version.txt ss-latest.deb && \
        install2.r -e shiny rmarkdown && \
        cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
        rm -rf /var/lib/apt/lists/* && \
        mkdir -p /var/log/shiny-server && \
        chown shiny.shiny /var/log/shiny-server && \
        mkdir -p /etc/services.d/shiny-server && \
        cd /etc/services.d/shiny-server && \
        echo '#!/bin/bash' > run && echo 'exec shiny-server > /var/log/shiny-server.log' >> run && \
        chmod +x run && \
        adduser rstudio shiny && \
        cd /
    fi

    if [ $"$ADD" == "none" ]; then
           echo "Nothing additional to add"
    fi


<a id="org9c660b6"></a>

## Encrypted sign in

    <!DOCTYPE html>

    <!--
    #
    # encrypted-sign-in.htm
    #
    # Copyright (C) 2009-17 by RStudio, Inc., MatrixDS
    #
    # This program is licensed to you under the terms of version 3 of the
    # GNU Affero General Public License. This program is distributed WITHOUT
    # ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THOSE OF NON-INFRINGEMENT,
    # MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Please refer to the
    # AGPL (http://www.gnu.org/licenses/agpl-3.0.txt) for more details.
    #
    -->
    <html>
    <head>
    <script type="text/javascript" src="/js/encrypt.min.js"></script>
    <script type="text/javascript">
    function prepare() {

       try {
          var payload = "rstudio" + "\n" + "matrix";
          var xhr = new XMLHttpRequest();
          xhr.open("GET", "/auth-public-key", true);
          xhr.onreadystatechange = function() {
             try {
                if (xhr.readyState == 4) {
                   if (xhr.status != 200) {
                      var errorMessage;
                      if (xhr.status == 0)
                         errorMessage = "Error: Could not reach server--check your internet connection";
                      else
                         errorMessage = "Error: " + xhr.statusText;

                      if (typeof(errorp.innerText) == 'undefined')
                         console.log(errorMessage);
                      else
                         console.log(errorMessage);
                   }
                   else {
                      var response = xhr.responseText;
                      var chunks = response.split(':', 2);
                      var exp = chunks[0];
                      var mod = chunks[1];
                      var encrypted = encrypt(payload, exp, mod);
                      document.getElementById('persist').value = 1;
                      document.getElementById('package').value = encrypted;
                      document.getElementById('clientPath').value = window.location.pathname;
                      document.realform.submit();
                   }
                }
             } catch (exception) {
                console.log("Error: " + exception);
             }
          };
          xhr.send(null);
       } catch (exception) {
          console.log("Error: " + exception);
       }
    }
    function submitRealForm() {
       if (prepare())
          document.realform.submit();
    }
    </script>

    </head>
    <form action="auth-do-sign-in" name="realform" method="POST">
       <input type="hidden" name="persist" id="persist" value=""/>
       <input type="hidden" name="appUri" value=""/>
       <input type="hidden" name="clientPath" id="clientPath" value=""/>
       <input id="package" type="hidden" name="v" value=""/>
    </form>
    <script>
      submitRealForm();
    </script>
    </body>
    </html>


<a id="org8979aa1"></a>

## Entrypoint

    #!/bin/bash -e

    mkdir -p /home/rstudio/.R/library

    cp /home/README.txt /home/rstudio/README.txt

    chown -R rstudio:rstudio /home/rstudio/.R
    [ -f  /home/rstudio/.Rprofile ] || echo '.libPaths("/home/rstudio/.R/library")' > /home/rstudio/.Rprofile
    chown rstudio:rstudio /home/rstudio/.Rprofile
    [ -f  /home/rstudio/.Renvron ] || echo 'R_LIBS=/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library:/home/rstudio/.R/library
    ' > /home/rstudio/.Renvron
    chown rstudio:rstudio /home/rstudio/.Renvron
    #start RStudio
    /init


<a id="org2d71656"></a>

## nginx conf

    http {

      map $http_upgrade $connection_upgrade {
          default upgrade;
          ''      close;
        }

      server {
        listen 80;

        location / {
          proxy_pass http://localhost:8787;
          proxy_redirect http://localhost:8787/ $scheme://$http_host/;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
          proxy_read_timeout 20d;
        }
      }
    }


<a id="org2317d66"></a>

## Additional Packages

    #Script for common package installation on MatrixDS docker image
    p<-c('reticulate')


    install.packages(p,dependencies = TRUE)


<a id="orgdceedad"></a>

## PAM helper

    #!/usr/bin/env sh

    ## Enforces the custom password specified in the PASSWORD environment variable
    ## The accepted RStudio username is the same as the USER environment variable (i.e., local user name).

    set -o nounset

    IFS='' read -r password

    [ "${USER}" = "${1}" ] && [ "${PASSWORD}" = "${password}" ]


<a id="org28c7ea8"></a>

## User settings

    alwaysSaveHistory="0"
    loadRData="0"
    saveAction="0"


<a id="orgee8bdf1"></a>

## Userconf

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


<a id="orgbe4a639"></a>

## Dockerfile

    FROM shrysr/rbase:v1

    COPY packages.R /usr/local/lib/R/packages.R

    #install R packages
    RUN R CMD javareconf && \
        Rscript /usr/local/lib/R/packages.R

    ARG RSTUDIO_VERSION
    ENV PATH=/usr/lib/rstudio-server/bin:$PATH

    #Creating etc folder at /usr/local/lib/R/ location Searce
    RUN mkdir -p /usr/local/lib/R/etc

    ## Download and install RStudio server & dependencies
    ## Attempts to get detect latest version, otherwise falls back to version given in $VER
    ## Symlink pandoc, pandoc-citeproc so they are available system-wide
    RUN apt-get update \
      && apt-get install -y --no-install-recommends \
    #    file \
        libapparmor1 \
        libcurl4-openssl-dev \
        libedit2 \
        lsb-release \
        psmisc \
        libclang-dev \
      && wget -O libssl1.0.0.deb http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb \
      && dpkg -i libssl1.0.0.deb \
      && rm libssl1.0.0.deb \
      && RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
      && [ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true \
      # hard code the latest v1.2
      && wget -q https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-1.2.1511-amd64.deb \
      && dpkg -i rstudio-server-1.2.1511-amd64.deb \
      #use this for latest
     # && wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
     # && dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
      && rm rstudio-server-*-amd64.deb \
      ## Symlink pandoc & standard pandoc templates for use system-wide
      && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
      && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
      && git clone https://github.com/jgm/pandoc-templates \
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
      && echo "rstudio:matrix" | chpasswd \
    	&& mkdir /home/rstudio \
    	&& chown rstudio:rstudio /home/rstudio \
    	&& addgroup rstudio staff \
      ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
      &&  echo 'rsession-which-r=/usr/bin/R' >> /etc/rstudio/rserver.conf \
      ## use more robust file locking to avoid errors when using shared volumes:
    #  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
      ## configure git not to request password each time
      && git config --system credential.helper 'cache --timeout=3600' \
      && git config --system push.default simple \
      ## Set up S6 init system
      && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
      && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
      && mkdir -p /etc/services.d/rstudio \
      && echo '#!/usr/bin/with-contenv bash \
              \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
              > /etc/services.d/rstudio/run \
      && echo '#!/bin/bash \
              \n rstudio-server stop' \
              > /etc/services.d/rstudio/finish

    COPY userconf.sh /etc/cont-init.d/userconf

    COPY pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper

    EXPOSE 8787

    COPY user-settings /home/rstudio/.rstudio/monitored/user-settings/
    # No chown will cause "RStudio Initalization Error"
    # "Error occurred during the transmission"; RStudio will not load.
    RUN chown -R rstudio:rstudio /home/rstudio/.rstudio


    ############ https://github.com/matrixds/tools/blob/master/rstudio/Dockerfile ##########

    RUN \
      apt-get update && apt-get install -y && \
      DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        default-jre default-jdk icu-devtools && apt-get clean

    COPY entrypoint.sh /entrypoint.sh

    #add encrypted auth html file
    COPY encrypted-sign-in.htm /usr/lib/rstudio-server/www/templates/encrypted-sign-in.htm


    RUN   usermod -u 1100 rstudio && \
          groupmod -g 1100 rstudio && \
          chown -R rstudio:rstudio /home/rstudio && \
          chmod +x /entrypoint.sh

    ENV PASSWORD matrix
    ENV DISABLE_AUTH true
    ENV ROOT TRUE
    WORKDIR /home/rstudio
    COPY readme.txt /home/readme.txt

    ENTRYPOINT ["sh", "-c", "/entrypoint.sh >>/var/log/stdout.log 2>>/var/log/stderr.log"]


<a id="orge43befb"></a>

## Container launch

    docker container run -itd -p 8787:8787 -v /Users/shrysr/my_projects/sr-ds-docker:/home/rstudio -e USER=shrysr -e PASSWORD=abcd shrysr/rstudio:v1


<a id="orgf86cb5b"></a>

# Shiny


<a id="orgf991fe5"></a>

## Environment and Profile

    R_LIBS=/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library:/srv/R/library

    .libPaths("/srv/R/library/")


<a id="org6218abf"></a>

## app.r

    #
    # This is a Shiny web application on MatrixDS.
    #
    # Find out more about building applications with Shiny here:
    #
    #    http://shiny.rstudio.com/
    #

    ##########################################################################################
    # This points the Shiny server tool to any libraries installed with RStudio
    # that means that any library you install on your RStudio instance in this project,
    # will be available to the shiny server
    ##########################################################################################

    .libPaths( c( .libPaths(), "/srv/.R/library") )

    ##########################################################################################
    # Here you can call all the required libraries for your code to run
    ##########################################################################################

    library(shiny)

    ##########################################################################################
    # For deploying tools on MatrixDS, we created this production variable
    # when set to true, your shiny app will run on the shiny server tool upon clicking open
    # when set to false, your shiny app will run when you hit the "Run App" button on RStudio
    ##########################################################################################

    production <- TRUE

    ##########################################################################################
    # The shiny server tool uses a different absolute path than RStudio.
    # this if statement denotes the correct path for the 2 values of the production variable
    ##########################################################################################

    if(production == FALSE) {
      #if you using the RStudio tool
      shiny_path <- "~/shiny-server/"
      home_path <- "~/"
    } else {
      #if you are using the shiny tool
      shiny_path <- "/srv/shiny-server/"
      home_path <- "/srv/"
    }

    ##########################################################################################
    # To call a file/artifact in your MatrixDS project use the following line of code
    # this example uses the function read.csv
    #  my_csv <- read.csv(paste0(home_path,"file_name.csv"))
    ##########################################################################################

    # Define UI for application that draws a histogram
    ui <- fluidPage(

       # Application title
       titlePanel("Old Faithful Geyser Data"),

       # Sidebar with a slider input for number of bins
       sidebarLayout(
          sidebarPanel(
             sliderInput("bins",
                         "Number of bins:",
                         min = 1,
                         max = 50,
                         value = 30)
          ),

          # Show a plot of the generated distribution
          mainPanel(
             plotOutput("distPlot")
          )
       )
    )

    # Define server logic required to draw a histogram
    server <- function(input, output) {

       output$distPlot <- renderPlot({
          # generate bins based on input$bins from ui.R
          x    <- faithful[, 2]
          bins <- seq(min(x), max(x), length.out = input$bins + 1)

          # draw the histogram with the specified number of bins
          hist(x, breaks = bins, col = 'darkgray', border = 'white')
       })
    }

    # Run the application
    shinyApp(ui = ui, server = server)


<a id="orgd9fcec2"></a>

## entrypoint

    #!/bin/bash

    mkdir -p /srv/shiny-server
    mkdir -p /srv/.R/library
    [ -f  /srv/.Rprofile ] || echo '.libPaths("/srv/.R/library/")' > /srv/.Rprofile
    [ -f  /srv/.Renvron ] || echo 'R_LIBS=/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library:/srv/.R/library
    ' > /srv/.Renvron

    if [ ! -d "/srv/shiny-server" ]
    then
      mkdir -p /srv/shiny-server
      cp -r /root/shiny-server/example_shiny/app.R /srv/shiny-server/
    else
      if [ ! "$(ls -A /srv/shiny-server)" ]
       then
         cp -r /root/shiny-server/example_shiny/app.R /srv/shiny-server/
      fi
    fi

    sh /usr/bin/shiny-server.sh


<a id="org4e8b98b"></a>

## shiny server script

    #!/bin/sh

    # Make sure the directory for individual app logs exists
    mkdir -p /var/log/shiny-server
    chown shiny.shiny /var/log/shiny-server

    if [ "$APPLICATION_LOGS_TO_STDOUT" = "false" ];
    then
        exec shiny-server 2>&1
    else
        # start shiny server in detached mode
        exec shiny-server 2>&1 &

        # push the "real" application logs to stdout with xtail
        exec xtail /var/log/shiny-server/
    fi


<a id="org1dc5ae3"></a>

## packages

    #Script for common package installation on MatrixDS docker image
    p<-c('reticulate')


    install.packages(p,dependencies = TRUE)


<a id="org8988f5f"></a>

## version


<a id="orgce85ca7"></a>

## Dockerfile

    FROM shrysr/rbase:v1

    COPY packages.R /usr/local/lib/R/packages.R

    #install R packages
    RUN R CMD javareconf && \
        Rscript /usr/local/lib/R/packages.R

    RUN apt-get update && apt-get install -y \
        gdebi-core \
        pandoc \
        pandoc-citeproc \
        libcurl4-gnutls-dev \
        libcairo2-dev \
        libxt-dev \
        xtail

    COPY entrypoint.sh /entrypoint.sh
    RUN mkdir -p /root/shiny-server/
    RUN mkdir -p /root/shiny-server/example_shiny/
    COPY app.R /root/shiny-server/example_shiny/app.R


    # Download and install shiny server
    RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
        VERSION=$(cat version.txt)  && \
        wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
        gdebi -n ss-latest.deb && \
        rm -f version.txt ss-latest.deb && \
        . /etc/environment && \
        R -e "install.packages(c('shiny', 'rmarkdown'), repos='$MRAN')" && \
        cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

    RUN \
      apt-get update && apt-get install -y && \
      DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        default-jre default-jdk \
        && apt-get clean && \
      usermod -u 1100 shiny && \
      groupmod -g 1100 shiny && \
      chown -R shiny:shiny /srv && \
      chown -R shiny:shiny /srv && \
      chmod +x /entrypoint.sh


    COPY shiny-server.sh /usr/bin/shiny-server.sh
    #CMD ["sh", "/usr/bin/shiny-server.sh"]
    ENTRYPOINT ["sh", "-c", "/entrypoint.sh >>/var/log/stdout.log 2>>/var/log/stderr.log"]


<a id="org719bf03"></a>

## Container launch

    docker container run -itd -p 3839:3839 -v /Users/shrysr/my_projects/sr-ds-docker/shiny-server/test_app/:/srv shrysr/shiny:v1


<a id="org6f1b9a6"></a>

# TODO Rstudio Server Preview

This layer will build the Rstudio server preview edition. It is a low priority task planned subsequent to getting the fundamental layers to work.


<a id="org38180fa"></a>

# Latest Libraries - Shiny and RStudio server


<a id="orgcbbe7eb"></a>

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


<a id="org8b415d0"></a>

## Dockerfile


<a id="org749f01b"></a>

### Container run command

    #/bin/bash
    docker container run -it --rm  -p 3838:3838 -p 8787:8787 \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/:/srv/shiny-server/test_app \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/log/shiny-server/:/var/log/shiny-server/ \
    shrysr/rstudio:v1


<a id="orge4c14c3"></a>

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


<a id="org318e6d4"></a>

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


<a id="org9a326c1"></a>

# Test Shiny App

A bunch of apps will be included here for the purpose of quickly testing functionality of widgets and etc. As such, the sample apps with the shiny server can also be used. Here, I would like to construct specific examples to have a look on whether all the components are working as expected. Perhaps like a test suite of apps.


<a id="org0378943"></a>

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


<a id="orgcd05b3f"></a>

# Experimental Containers

    docker image ls

    FROM shrysr/datasciencer as base1
    FROM rocker/tidyverse
    COPY  --from=base1 * .


<a id="org1230e96"></a>

# Basic Template

Matt Dancho's original Dockerfile as of <span class="timestamp-wrapper"><span class="timestamp">[2020-01-02 Thu]</span></span>, placed here for ready reference.

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
