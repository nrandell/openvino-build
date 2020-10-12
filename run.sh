docker stop openvino
docker rm openvino
docker run --rm --name openvino -it --privileged \
    -v /dev:/dev \
    -v $HOME/data:/data \
    --network=host \
    nrandell/openvino
