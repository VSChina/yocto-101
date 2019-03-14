
FROM lindisjtu/lighter-azure-sdk:latest

# extract toolchain
WORKDIR /usr/xcc
RUN tar xf gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz && \
    mv gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu/* aarch64-linux-gnu && \
    rm gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz

# Build openssl, curl, uuid
WORKDIR /work
RUN apk add --no-cache --virtual .build-deps perl make cmake && \
    wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz && \
    tar -xvf openssl-1.0.2o.tar.gz && \
    cd openssl-1.0.2o && \
    ./Configure linux-generic32 shared --prefix=${QEMU_LD_PREFIX}/usr --openssldir=${QEMU_LD_PREFIX}/usr && \
    make && \
    make install && \
    rm /work/openssl-1.0.2o.tar.gz && \
    rm -rf /work/openssl-1.0.2o && \
    cd .. && \
    wget http://curl.haxx.se/download/curl-7.60.0.tar.gz && \
    tar -xvf curl-7.60.0.tar.gz && \
    cd curl-7.60.0 && \
    ./configure --with-sysroot=${QEMU_LD_PREFIX} --prefix=${QEMU_LD_PREFIX}/usr --target=${CROSS_TRIPLE} --with-ssl --with-zlib --host=${CROSS_TRIPLE} --build=x86_64-pc-linux-uclibc && \
    make && \
    make install && \
    rm /work/curl-7.60.0.tar.gz && \
    rm -rf /work/curl-7.60.0 && \
    cd .. && \
    wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32-rc2.tar.gz && \
    tar -xvf util-linux-2.32-rc2.tar.gz && \
    cd util-linux-2.32-rc2 && \
    ./configure --prefix=${QEMU_LD_PREFIX}/usr --with-sysroot=${QEMU_LD_PREFIX} --target=${CROSS_TRIPLE} --host=${CROSS_TRIPLE} --disable-all-programs  --disable-bash-completion --enable-libuuid && \
    make && \
    make install && \
    rm /work/util-linux-2.32-rc2.tar.gz && \
    rm -rf /work/util-linux-2.32-rc2

# Build Application
COPY azureIoT /work/azure-iot-sdk-c/azureIoT

# Add user app into CMake build structure
RUN echo "add_subdirectory(azureIoT)" >> /work/azure-iot-sdk-c/CMakeLists.txt

WORKDIR /work/azure-iot-sdk-c

RUN mkdir cmake && \
    cd cmake && \
    cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .. && \
    make

RUN find . -name azure_exe
# binary file can be found in /work/AzureBuild/azure-iot-sdk-c/cmake/azureIoT/azure_exe
