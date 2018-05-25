FROM ubuntu:18.04
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

ENV RUN_SCRIPT ~/.bashrc

# Install additional packages
RUN apt-get --yes update && \
    apt-get --yes upgrade && \
    apt-get --yes install gfortran make cmake less git python3 python3-pip python-dev && \
    apt-get --yes install build-essential doxygen cloc rsync cpio libquadmath0 && \
    pip3 install --upgrade pip && \
    pip3 install pytest pytest-xdist pypact

WORKDIR /

CMD /bin/bash $RUN_SCRIPT
