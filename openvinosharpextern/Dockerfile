FROM openvino/ubuntu20_runtime as build

USER root
WORKDIR /source

# ARG DEPENDENCIES="autoconf \
#                   automake \
#                   build-essential \
#                   cmake \
#                   curl"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -k -L https://github.com/shimat/opencvsharp/archive/4.5.1.20201229.zip --output opencvsharp.zip \
    && unzip opencvsharp.zip \
    && rm opencvsharp.zip \
    && mv opencvsharp-* opencvsharp 

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

FROM mcr.microsoft.com/dotnet/sdk:5.0.100-focal
ARG NUGET_KEY

WORKDIR /build
COPY --from=build /install/lib/libOpenCvSharpExtern.so ./

COPY "Nick.OpenVinoSharp4.ubuntu.*" ./
RUN mkdir /install \
     && dotnet pack -o /install


RUN dotnet nuget push /install/*nupkg --source https://api.nuget.org/v3/index.json --api-key ${NUGET_KEY}
