FROM ubuntu:16.04
MAINTAINER UKAEA <admin@fispact.ukaea.uk>

# Build-time metadata as defined at http://label-schema.org
ARG PROJECT_NAME
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="$PROJECT_NAME" \
      org.label-schema.description="Ubuntu docker image for FISPACT-II" \
      org.label-schema.url="http://fispact.ukaea.uk/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fispact/docker_ubuntu" \
      org.label-schema.vendor="UKAEA" \
      org.label-schema.version=$VERSION \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.schema-version="1.0"

# some environment variables for regression testing
ENV FISPACT_SYSTEM_TESTS_REF ubuntu_16.04_gfortran_5_xsbinaries
ENV PYTHONDONTWRITEBYTECODE 1.
ENV PYTEST_VERBOSE line

WORKDIR /

# Install additional packages
RUN apt-get --yes update && \
    apt-get --yes upgrade && \
    apt-get --yes install gfortran make cmake less git python3 python3-pip python-dev && \
    apt-get --yes install build-essential doxygen cloc rsync cpio libquadmath0 wget && \
    pip3 install pytest pytest-xdist pypact && \
    wget https://download.open-mpi.org/release/open-mpi/v3.0/openmpi-3.0.2.tar.bz2 && \
    tar jxfv openmpi-3.0.2.tar.bz2 && cd openmpi-3.0.2 && ./configure && make -j4 && make install && \
    rm -rf /openmpi-3.0.2.tar.bz2 && mkdir /nuclear_data && cd /nuclear_data && \
    wget http://www.ccfe.ac.uk/FISPACT-II/Release-4.0/nuclear_data/EAF2010data.tar.bz2 && \
    wget http://www.ccfe.ac.uk/FISPACT-II/Release-4.0/nuclear_data/ebins.tar.bz2 && \
    wget http://www.ccfe.ac.uk/FISPACT-II/Release-4.0/nuclear_data/decay.tar.bz2 && \
    tar jxfv EAF2010data.tar.bz2 && tar jxfv ebins.tar.bz2 && tar jxfv decay.tar.bz2 && \
    rm -rf EAF2010data.tar.bz2 ebins.tar.bz2 decay.tar.bz2

WORKDIR /

ENV LD_LIBRARY_PATH /usr/local/lib
