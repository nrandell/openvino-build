FROM nrandell/openvino as build

USER root
WORKDIR /source

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

FROM mcr.microsoft.com/dotnet/sdk:5.0.100-rc.1-buster-slim
ARG NUGET_KEY

WORKDIR /build
COPY --from=build /install/lib/libOpenCvSharpExtern.so ./

COPY "Nick.OpenVinoSharp4.ubuntu.18.04-x64.*" ./
RUN mkdir /install \
     && dotnet pack -o /install


RUN dotnet nuget push ./install/*.nupkg --source https://api.nuget.org/v3/index.json --api-key ${NUGET_KEY}
