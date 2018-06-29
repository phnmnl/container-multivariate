FROM container-registry.phenomenal-h2020.eu/phnmnl/rbase

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

ENV TOOL_NAME=multivariate
ENV TOOL_VERSION=2.3.12
ENV CONTAINER_VERSION=1.3
ENV CONTAINER_GITHUB=https://github.com/phnmnl/container-multivariate

LABEL version="${CONTAINER_VERSION}"
LABEL software.version="${TOOL_VERSION}"
LABEL software="${TOOL_NAME}"
LABEL base.image="container-registry.phenomenal-h2020.eu/phnmnl/rbase"
LABEL description="Transforms the dataMatrix intensity values."
LABEL website="${CONTAINER_GITHUB}"
LABEL documentation="${CONTAINER_GITHUB}"
LABEL license="${CONTAINER_GITHUB}"
LABEL tags="Metabolomics"

# Update, install dependencies, clone repos and clean
RUN apt-get update -qq  && \
    apt-get install --no-install-recommends -y git make g++ && \
    git clone -b v${TOOL_VERSION} https://github.com/workflow4metabolomics/multivariate /files/multivariate && \
    echo 'options("repos"="http://cran.rstudio.com")' >> /etc/R/Rprofile.site && \
    R -e "install.packages(c('batch','RUnit'), dependencies = TRUE)" && \
    R -e "source('http://bioconductor.org/biocLite.R') ; biocLite('ropls')" && \
    apt-get purge -y git g++ make && \
    apt-get clean  && \
    apt-get autoremove -y  && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Make tool accessible through PATH
ENV PATH=$PATH:/files/multivariate

# Make test script accessible through PATH
ENV PATH=$PATH:/files/multivariate/test

# Define Entry point script
ENTRYPOINT ["/files/multivariate/multivariate_wrapper.R"]
