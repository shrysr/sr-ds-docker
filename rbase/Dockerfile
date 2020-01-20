FROM shrysr/asmith:v1

LABEL maintainer="Shreyas Ragavan <sr@eml.cc>" \
	version="1.0"

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

COPY packages.R /usr/local/lib/R/packages.R
COPY custom_packages.R /usr/local/lib/R/custom_packages.R

# Install Basic R packages for datascience and ML
RUN R CMD javareconf && \
    Rscript /usr/local/lib/R/packages.R

# Install custom set of R packages. This is on a separate layer for efficient image construction
RUN Rscript /usr/local/lib/R/custom_packages.R
