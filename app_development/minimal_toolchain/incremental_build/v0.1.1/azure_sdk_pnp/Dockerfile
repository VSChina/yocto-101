# devicedevex.azurecr.io/azure-sdk-pnp:0.1.1
FROM devicedevex.azurecr.io/linux-arm64:0.1.1

RUN mkdir -p /work
WORKDIR /work

# Download openssl, curl, uuid
RUN wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz && \
    wget http://curl.haxx.se/download/curl-7.60.0.tar.gz && \
    wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32-rc2.tar.gz

# Download Azure sdk
RUN apk add --no-cache git bash make cmake && \
    git clone -b private-preview --recursive https://dilin-MS:<token>@github.com/Azure/azure-iot-sdk-c-pnp && \
    apk del --no-cache git

COPY launch.sh /usr/bin/launch.sh