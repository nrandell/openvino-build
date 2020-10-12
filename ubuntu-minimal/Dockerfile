FROM ubuntu:18.04

USER root
WORKDIR /

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cpio \
    curl \
    && rm -rf /var/lib/apt/lists/*

ARG package_url=https://registrationcenter-download.intel.com/akdlm/irc_nas/17062/l_openvino_toolkit_p_2021.1.110.tgz
ARG TEMP_DIR=/tmp/openvino_installer

WORKDIR ${TEMP_DIR}
RUN curl -k -L ${package_url} --output openvino.tgz

# install product by installation script
ENV INTEL_OPENVINO_DIR /opt/intel/openvino_2021
ENV DEBIAN_FRONTEND noninteractive
RUN tar -xzf ${TEMP_DIR}/*.tgz --strip 1
RUN sed -i 's/decline/accept/g' silent.cfg && \
    ${TEMP_DIR}/install.sh -s silent.cfg && \
    ${INTEL_OPENVINO_DIR}/install_dependencies/install_openvino_dependencies.sh

WORKDIR /tmp
RUN rm -rf ${TEMP_DIR}

# Post-installation cleanup and setting up OpenVINO environment variables
RUN if [ -f "${INTEL_OPENVINO_DIR}"/bin/setupvars.sh ]; then \
        printf "\nsource \${INTEL_OPENVINO_DIR}/bin/setupvars.sh\n" >> /root/.bashrc; \
    fi;

WORKDIR ${INTEL_OPENVINO_DIR}

CMD ["/bin/bash"]
