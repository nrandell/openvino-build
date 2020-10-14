FROM nrandell/openvino-minimal AS openvino

FROM mcr.microsoft.com/dotnet/runtime:5.0.0-rc.2-buster-slim
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgdiplus \
    libc6-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*



COPY --from=openvino ["/opt/intel/openvino_2021", "/opt/intel/openvino_2021"]
