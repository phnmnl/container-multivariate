FROM ubuntu:14.04

MAINTAINER Etienne Thevenot (etienne.thevenot@cea.fr)

# Update and upgrade system
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install r-base git \
    && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Install R and other needed packages
RUN R -e "install.packages('batch', lib='/usr/lib/R/library', dependencies = TRUE, repos='http://mirrors.ebi.ac.uk/CRAN')"
RUN R -e "source('http://bioconductor.org/biocLite.R') ; biocLite('ropls')"

# Clone tool
RUN git clone -b v2.3.6 https://github.com/workflow4metabolomics/multivariate.git /files/multivariate

# Make it executable
RUN chmod a+rx /files/multivariate/multivariate_wrapper.R && cp /files/multivariate/multivariate_wrapper.R /usr/local/bin/

# Define Entry point script
ENTRYPOINT ["/files/multivariate/multivariate_wrapper.R"]
