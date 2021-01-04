FROM ubuntu:20.04

USER root
WORKDIR /

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Creating user openvino
RUN useradd -ms /bin/bash openvino && \
    chown openvino -R /home/openvino

ARG package_url=https://registrationcenter-download.intel.com/akdlm/irc_nas/17504/l_openvino_toolkit_runtime_ubuntu20_p_2021.2.185.tgz
ARG TEMP_DIR=/tmp/openvino_installer

ARG DEPENDENCIES="autoconf \
                  automake \
                  build-essential \
                  cmake \
                  cpio \
                  curl \
                  gnupg2 \
                  libdrm2 \
                  libglib2.0-0 \
                  lsb-release \
                  libgtk-3-0 \
                  libtool \
                  udev \
                  unzip \
                  dos2unix"

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${DEPENDENCIES} && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /thirdparty
RUN sed -Ei 's/# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update && \
    apt-get source ${DEPENDENCIES} && \
    rm -rf /var/lib/apt/lists/*

# setup Python
ENV PYTHON python3.6
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip python3-dev lib${PYTHON}-minimal && \
    rm -rf /var/lib/apt/lists/*

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

# installing dependencies for package
#WORKDIR /tmp
#RUN ${PYTHON} -m pip install --no-cache-dir setuptools && \
#    find "${INTEL_OPENVINO_DIR}/" -type f -name "*requirements*.*" -path "*/${PYTHON}/*" -exec ${PYTHON} -m pip install --no-cache-dir -r "{}" \; && \
#    find "${INTEL_OPENVINO_DIR}/" -type f -name "*requirements*.*" -not -path "*/post_training_optimization_toolkit/*" -not -name "*windows.txt"  -not -name "*ubuntu16.txt" -not -path "*/python3*/*" -not -path "*/python2*/*" -exec ${PYTHON} -m pip install --no-cache-dir -r "{}" \;
#
#WORKDIR ${INTEL_OPENVINO_DIR}/deployment_tools/open_model_zoo/tools/accuracy_checker
#RUN source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh && \
#    ${PYTHON} -m pip install --no-cache-dir -r ${INTEL_OPENVINO_DIR}/deployment_tools/open_model_zoo/tools/accuracy_checker/requirements.in && \
#    ${PYTHON} ${INTEL_OPENVINO_DIR}/deployment_tools/open_model_zoo/tools/accuracy_checker/setup.py install
#
#WORKDIR ${INTEL_OPENVINO_DIR}/deployment_tools/tools/post_training_optimization_toolkit
#RUN if [ -f requirements.txt ]; then \
#        ${PYTHON} -m pip install --no-cache-dir -r ${INTEL_OPENVINO_DIR}/deployment_tools/tools/post_training_optimization_toolkit/requirements.txt && \
#        ${PYTHON} ${INTEL_OPENVINO_DIR}/deployment_tools/tools/post_training_optimization_toolkit/setup.py install; \
#    fi;

# Setup for GPU
WORKDIR /tmp/opencl
RUN usermod -aG video openvino
RUN apt-get update && \
    apt-get install -y --no-install-recommends ocl-icd-libopencl1 && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-gmmlib_19.3.2_amd64.deb" --output "intel-gmmlib_19.3.2_amd64.deb" && \
    curl -L "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-igc-core_1.0.2597_amd64.deb" --output "intel-igc-core_1.0.2597_amd64.deb" && \
    curl -L "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-igc-opencl_1.0.2597_amd64.deb" --output "intel-igc-opencl_1.0.2597_amd64.deb" && \
    curl -L "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-opencl_19.41.14441_amd64.deb" --output "intel-opencl_19.41.14441_amd64.deb" && \
    curl -L "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-ocloc_19.41.14441_amd64.deb" --output "intel-ocloc_19.41.14441_amd64.deb" && \
    dpkg -i /tmp/opencl/*.deb && \
    ldconfig && \
    rm -rf /tmp/opencl

# Post-installation cleanup and setting up OpenVINO environment variables
RUN if [ -f "${INTEL_OPENVINO_DIR}"/bin/setupvars.sh ]; then \
        printf "\nsource \${INTEL_OPENVINO_DIR}/bin/setupvars.sh\n" >> /home/openvino/.bashrc; \
        printf "\nsource \${INTEL_OPENVINO_DIR}/bin/setupvars.sh\n" >> /root/.bashrc; \
    fi;
RUN find "${INTEL_OPENVINO_DIR}/" -name "*.*sh" -type f -exec dos2unix {} \;

WORKDIR ${INTEL_OPENVINO_DIR}/deployment_tools/model_optimizer/install_prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/* && \
    ./install_prerequisites_onnx.sh

USER openvino

WORKDIR ${INTEL_OPENVINO_DIR}

CMD ["/bin/bash"]
