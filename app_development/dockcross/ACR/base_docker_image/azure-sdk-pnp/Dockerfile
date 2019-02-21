# base docker image for azure-c-sdk-pnp library(preview)
# Replace proper <my-token> before building this Dockerfile

FROM dockcross/linux-arm64

ENV DEFAULT_DOCKCROSS_IMAGE azure-sdk-pnp

# Create a work directory and switch to it
RUN mkdir /work/AzureBuild
WORKDIR /work/AzureBuild

# Set up environment variables in preparation for the builds to follow
# These will need to be modified for the corresponding locations in the toolchain being used
ENV WORK_ROOT=/work/AzureBuild \
    TOOLCHAIN_NAME=aarch64-unknown-linux-gnueabi
ENV NM=${CROSS_ROOT}/bin/${TOOLCHAIN_NAME}-nm \
    RANLIB=${CROSS_ROOT}/bin/${TOOLCHAIN_NAME}-ranlib \
    LDFLAGS="-L${QEMU_LD_PREFIX}/usr/lib" \ 
    LIBS="-lssl -lcrypto -ldl -lpthread"

# OpenSSL
RUN wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz && \
    tar -xvf openssl-1.0.2o.tar.gz && \
    cd openssl-1.0.2o && \
    ./Configure linux-generic32 shared --prefix=${QEMU_LD_PREFIX}/usr --openssldir=${QEMU_LD_PREFIX}/usr && \
    make && \
    make install && \
    rm ${WORK_ROOT}/openssl-1.0.2o.tar.gz && \
    rm -rf ${WORK_ROOT}/openssl-1.0.2o

# cURL
RUN wget http://curl.haxx.se/download/curl-7.60.0.tar.gz && \
    tar -xvf curl-7.60.0.tar.gz && \
    cd curl-7.60.0 && \
    ./configure --with-sysroot=${QEMU_LD_PREFIX} --prefix=${QEMU_LD_PREFIX}/usr --target=${TOOLCHAIN_NAME} --with-ssl --with-zlib --host=${TOOLCHAIN_NAME} --build=x86_64-pc-linux-uclibc && \
    make && \
    make install && \
    rm ${WORK_ROOT}/curl-7.60.0.tar.gz && \
    rm -rf ${WORK_ROOT}/curl-7.60.0

# libuuid
RUN wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32-rc2.tar.gz && \
    tar -xvf util-linux-2.32-rc2.tar.gz && \
    cd util-linux-2.32-rc2 && \
    ./configure --prefix=${QEMU_LD_PREFIX}/usr --with-sysroot=${QEMU_LD_PREFIX} --target=${TOOLCHAIN_NAME} --host=${TOOLCHAIN_NAME} --disable-all-programs  --disable-bash-completion --enable-libuuid && \
    make && \
    make install && \
    rm ${WORK_ROOT}/util-linux-2.32-rc2.tar.gz && \
    rm -rf ${WORK_ROOT}/util-linux-2.32-rc2

# Azure-sdk-c-pnp
# Replace proper <my-token> before building this Dockerfile
RUN git clone -b private-preview --recursive https://dilin-MS:<my-token>/dilin-MS/azure-iot-sdk-c-pnp