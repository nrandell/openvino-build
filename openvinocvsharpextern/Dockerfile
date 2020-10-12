FROM nrandell/openvino as build

USER root
WORKDIR /source

# RUN wget https://github.com/shimat/opencvsharp/archive/${OPENCVSHARP_VERSION}.zip && \
RUN curl -k -L https://github.com/shimat/opencvsharp/archive/master.zip --output opencvsharp.zip \
    && unzip opencvsharp.zip \
    && rm opencvsharp.zip \
    && mv opencvsharp-master opencvsharp 

WORKDIR /source/opencvsharp/src/OpenCvSharpExtern/
COPY ["include_opencv.h", "CMakeLists.txt", "./"]

RUN cmake \
    -D OpenCV_DIR=${INTEL_OPENVINO_DIR}/opencv/cmake \
    -D InferenceEngine_DIR=${INTEL_OPENVINO_DIR}/inference_engine/share \
    -D TBB_DIR=${INTEL_OPENVINO_DIR}/inference_engine/external/tbb/cmake \
    -D CMAKE_INSTALL_PREFIX=/install \
    /source/opencvsharp/src

RUN make 
RUN make install
