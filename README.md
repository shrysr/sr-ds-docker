
# Table of Contents

1.  [Preamble](#org49064c3)
    1.  [Plans and potential goals](#org241e34a)
2.  [Notes](#orgba9d454)
    1.  [Tools and methodology](#orge7b5d72)
    2.  [Running these files](#orgbb05978)
    3.  [Launching the docker container](#org336ff89)
    4.  [Strategy](#org848633c)
    5.  [Status Log](#orgfb012a7)
3.  [Latest Libraries - Shiny and RStudio server](#org6d80d5b)
4.  [Test App](#orgc47d404)
5.  [Basic Template](#org28f1cb2)


<a id="org49064c3"></a>

# Preamble

The starting point of this dockerfile is from [Matt Dancho's shinyauth](https://github.com/business-science/shinyauth) example file, which is generally referred to as the base template in this document. This repo will reflect my effort to construct a docker image to use with datascience projects, and thus take a step towards establishing a clear methodology for reproducible results in my work. The initial focus will be on R, and will slowly extend to including Python as well.

In this regard, the [Data Science School's docker image](https://hub.docker.com/r/datascienceschool/rpython) is quite useful as a comprehensive reference.


<a id="org241e34a"></a>

## Plans and potential goals

-   [ ] start with providing specific versions of atleast the major components.
-   [ ] figure out an efficient method to take care of package versions for R
-   [ ] streamline the image and layers pulling in existing official docker images.
-   [ ] consider using the Ubuntu or any other suitable OS image to build and evaluate the benefits of doing so.
-   [ ] Create tests to ensure the docker image is working
-   [ ] Add a file with the R session information to be automatically generated with each container and printed to a file in the working directory.
-   [ ] Add Rstudio server


<a id="orgba9d454"></a>

# Notes

*There are a bunch of general docker related notes and references [on my website](https://shreyas.ragavan.co/docs/docker-notes/).*


<a id="orge7b5d72"></a>

## Tools and methodology

I am currently creating dockerfiles via source code blocks inserted into Org mode documents. i.e a single Readme.org is where I will edit all the dockerfiles in this repository, which are then tangled into the dockerfiles automatically.

The Org mode format can be leveraged to record comments and notes about each dockerfile and setup within the readme document itself thus creating a literate environment.

Since each template is under it's own Org heading, the specific heading can even be exported as an org file which can be externally tangled into these source files without needing the installation of Emacs. This makes the possibilities rather interesting. Down the line, further optimisations will be made

Beyond this, tools like [docker-tramp](https://github.com/emacs-pe/docker-tramp.el/blob/master/README.md?utm_source=share&utm_medium=ios_app&utm_name=iossmf) can be used with Emacs to have org babel source blocks connect directly to docker instances and have the results printed in the local buffer. This enables a standard environment for development.


<a id="orgbb05978"></a>

## Running these files

The following options exist:

1.  Pull the latest image from docker hub : `docker pull shrysr/datasciencer` and run the container. This will reference the [Adding All libraries to the Template](#org6d80d5b), wherein the latest versions of all the files will be used.
2.  Copy the contents of the dockerfile and paste into your docker file.
3.  Alternately, this repo can be cloned, and the dockerfile can be specified with the `f` flag for example `docker build . -f ~/temp/testdocker`


<a id="org336ff89"></a>

## Launching the docker container

These are some variations of snippets used for connecting to the container placed here for ready reference.

*Note that the local test\_app folder has to be created*

    #+/bin/bash
    docker container run --rm  -p 3838:3838 \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/:/srv/shiny-server/test_app \
    -v /Users/shrysr/my_projects/sr-ds-docker/test_app/log/shiny-server/:/var/log/shiny-server/ \
    umaptest


<a id="org848633c"></a>

## Strategy

-   Using the `:latest` tag is useful only for some some circumstances, because there seems to be no point in using docker images if specific versions of libraries and packages are not set and updated with care from time to time. However, atleast one image may be worth having referencing the latest version of all the libraries. This container could be used for a test to know compatibility with the latest libraries.
-   Dockerhub has a build feature wherein a github / bitbucket repo can be linked and each new  commit will trigger a build. A specific location can also be specified for the dockerfile, or a git branch name or tag. Though caching and etc are possible, the build time appears to be no better than local build time. However, I still think this is a good feature to note and turn on. This can be accessed on the 'Builds' tab on Dockerhub.


<a id="orgfb012a7"></a>

## Status Log

> Current Status, <span class="timestamp-wrapper"><span class="timestamp">[2020-01-03 Fri]</span></span>
> This dockerfile will launch a shiny server to listen at the specified port. Some additional libraries like umap, glmnet, inspectdf, DataExplorer have been added in layers. The github repo is linked to the [image on dockerhub](https://hub.docker.com/repository/docker/shrysr/datasciencer).


<a id="org6d80d5b"></a>

# Latest Libraries - Shiny and RStudio server

OS Package list

1.  pandoc
2.  pandoc-cite

R Libraries being installed in addition to the base template:

1.  glmnet
2.  Umap
3.  inspectdf
4.  DataExplorer

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


<a id="orgc47d404"></a>

# Test App

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


<a id="org28f1cb2"></a>

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
