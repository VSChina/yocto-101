FROM dockcross/linux-arm64

ENV DEFAULT_DOCKCROSS_IMAGE my_cool_image

# Create a work directory and switch to it
RUN mkdir AzureBuild
WORKDIR AzureBuild

# Download the Azure IoT SDK for C
RUN git clone --recursive https://github.com/azure/azure-iot-sdk-c.git

# Download OpenSSL source and expand it
RUN wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz
RUN tar -xvf openssl-1.0.2o.tar.gz

# Download cURL source and expand it
RUN wget http://curl.haxx.se/download/curl-7.60.0.tar.gz
RUN tar -xvf curl-7.60.0.tar.gz

# Download the Linux utilities for libuuid and expand it
RUN wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32-rc2.tar.gz
RUN tar -xvf util-linux-2.32-rc2.tar.gz

# Set up environment variables in preparation for the builds to follow
# These will need to be modified for the corresponding locations in the toolchain being used
ENV WORK_ROOT=/work/AzureBuild
ENV TOOLCHAIN_NAME=aarch64-unknown-linux-gnueabi
ENV NM=${CROSS_ROOT}/bin/${TOOLCHAIN_NAME}-nm
ENV RANLIB=${CROSS_ROOT}/bin/${TOOLCHAIN_NAME}-ranlib
ENV LDFLAGS="-L${QEMU_LD_PREFIX}/usr/lib"
ENV LIBS="-lssl -lcrypto -ldl -lpthread"

# Build OpenSSL
WORKDIR openssl-1.0.2o
RUN ./Configure linux-generic32 shared --prefix=${QEMU_LD_PREFIX}/usr --openssldir=${QEMU_LD_PREFIX}/usr
RUN make
RUN make install
WORKDIR ..

# Build cURL
WORKDIR curl-7.60.0
RUN ./configure --with-sysroot=${QEMU_LD_PREFIX} --prefix=${QEMU_LD_PREFIX}/usr --target=${TOOLCHAIN_NAME} --with-ssl --with-zlib --host=${TOOLCHAIN_NAME} --build=x86_64-pc-linux-uclibc
RUN make
RUN make install
WORKDIR ..

# Build uuid
WORKDIR util-linux-2.32-rc2
RUN ./configure --prefix=${QEMU_LD_PREFIX}/usr --with-sysroot=${QEMU_LD_PREFIX} --target=${TOOLCHAIN_NAME} --host=${TOOLCHAIN_NAME} --disable-all-programs  --disable-bash-completion --enable-libuuid
RUN make
RUN make install
WORKDIR ..

WORKDIR azure-iot-sdk-c

# Create a working directory for the cmake operations
RUN mkdir cmake
WORKDIR cmake

# Build the SDK. This will use the OpenSSL, cURL and uuid binaries that we built before
RUN cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DCMAKE_INSTALL_PREFIX=${QEMU_LD_PREFIX}/usr ..
RUN make
RUN make install

# Finally a sanity check to make sure the files are there
RUN ls -al ${QEMU_LD_PREFIX}/usr/lib
RUN ls -al ${QEMU_LD_PREFIX}/usr/include

# Go to project root
WORKDIR ../..

# Build your Azure application
# Copy a directory from the host containing the files to build setting ownership at the same time
ADD myapp  ${WORK_ROOT}/myapp

# Sanity check
RUN ls -al myapp

# Switch to application directory
WORKDIR myapp

# Create and switch to cmake directory
RUN mkdir cmake
WORKDIR cmake

# Generate the makefiles with the same toolchain file and build
RUN cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} ..
RUN make

# There should be an executable called myapp
RUN ls -al azure_exe