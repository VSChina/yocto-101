# lighter-azure-sdk
FROM lindisjtu/lighter-linux-arm64:latest

RUN mkdir -p /work
WORKDIR /work

RUN apk add --no-cache --virtual .build-deps git && \
    git clone --recursive https://github.com/azure/azure-iot-sdk-c.git && \
    apk del --no-cache .build-deps

