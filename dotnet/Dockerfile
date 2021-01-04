FROM openvino/ubuntu20_runtime AS openvino

FROM mcr.microsoft.com/dotnet/runtime:5.0.0-focal
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    libgdiplus \
    libc6-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=openvino ["/opt/intel/openvino_2021", "/opt/intel/openvino_2021"]
ENV INTEL_OPENVINO_DIR=/opt/intel/openvino_2021
ENV LD_LIBRARY_PATH=${INTEL_OPENVINO_DIR}/inference_engine/external/mkltiny_lnx/lib:${INTEL_OPENVINO_DIR}/inference_engine/external/gna/lib:${INTEL_OPENVINO_DIR}/inference_engine/external/hddl/lib:${INTEL_OPENVINO_DIR}/inference_engine/external/hddl_unite/lib:${INTEL_OPENVINO_DIR}/inference_engine/external/tbb/lib:${INTEL_OPENVINO_DIR}/deployment_tools/ngraph/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/lib/intel64:${INTEL_OPENVINO_DIR}/opencv/lib

