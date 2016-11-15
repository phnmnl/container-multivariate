FROM ubuntu:14.04

MAINTAINER Etienne Thevenot (etienne.thevenot@cea.fr)

# Install tool and its dependencies packages
RUN \
     apt-get update  \
  && apt-get -y install --no-install-recommends \
       git \
       liblwp-protocol-https-perl \
       r-base \
  && R -e "install.packages('batch', lib='/usr/lib/R/library', dependencies = TRUE, repos='http://mirrors.ebi.ac.uk/CRAN')"  \
  && R -e "source('http://bioconductor.org/biocLite.R') ; biocLite('ropls')"  \
  && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*


# Clone tool
RUN git clone -b v2.3.6 https://github.com/workflow4metabolomics/multivariate.git /files/multivariate

# Make it executable
RUN chmod a+rx /files/multivariate/multivariate_wrapper.R && cp /files/multivariate/multivariate_wrapper.R /usr/local/bin/

# Define Entry point script
ENTRYPOINT ["/files/multivariate/multivariate_wrapper.R"]
