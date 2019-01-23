# Develop Application with Dockcross Toolchain

## Background

Say we have a target machine running yocto image, we are going to develop an application and run on that target machine in the next step. We can choose Yocto's toolchain, yocto esdk, to develop application( see [esdk](../esdk.md)). We can also try the [dockcross](https://github.com/dockcross/dockcross) to complete this work.

Dockcross is several cross-compile toolchains in Docker images developed and maintained by several personal IT programmers.

## Build a Hello-world Application

Create a work directory `hello-world`, which folder structure is as follow. (You can download the code directly from [here](./examples/dockcross_hello/).)

```bash
.
├── compile.sh
├── my_app
│   └── hello.c
└── my_exe
```

compile.sh

```bash
#!/bin/bash

set -e

if [ $# -lt 2 ]; then
        echo "Usage: ./compile.sh <myapp.c> <output_dir> <dockcross-toolchain-bin>"
        echo "Example: ./compile.sh hello.c ."
        echo "  Or"
        echo "  ./compile.sh hello.c . dockcross-linux-armv7"
        exit 1
elif [ ! -f $1 ]; then
        echo "The input file does not exist!"
        exit 1
elif [ ! -d $2 ]; then
        mkdir -p $2
fi

myapp=$1
output_dir=$2
dockcross_exe={$3:-"dockcross-linux-arm64"}

filename=$(basename $myapp)
myapp_binary="${filename%.*}"

dockcross_exe="dockcross-linux-arm64"
$dockcross_exe bash -c '$CC '${myapp}' -o '${output_dir}/${myapp_binary}''

```

hello.c

```bash
#include <stdio.h>

int main(int argc, char *argv[])
{
  printf("Hello cross-compilation world!\n");
  return 0;
}
```

Run the following command to get a wanted cross-compile toolchain.

```bash
docker run --rm dockcross/linux-arm64 >./dockcross-linux-arm64
PATH=${PWD}:$PATH
```

Compile file to get a executable binary, which can run on target machine. Use the command `file` to check the binary's file information.

```bash
sh ./compile.sh my_app/hello.c my_exe/
file my_exe/hello
```

Copy the `hello` binary file to raspberry pi target machine, and test the executable file.

## Build an Azure IoT Application

### Edit File to Develop Application

Create a work directory `azure-app`, which folder structure is as follow. (You can download the code directly from [here](./examples/dockcross_azure/).)

```bash
.
├── Dockerfile
└── myapp
    ├── CMakeLists.txt
    └── iothub_convenience_sample.c
```

* Dockerfile

```bash
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
RUN ls -al myapp
```

* myapp/CMakeLists.txt

```bash
cmake_minimum_required(VERSION 2.8.11)
project(myapp_project)

# The demonstration uses C99 but it could just as easily be a C++ application
set (CMAKE_C_FLAGS "--std=c99 ${CMAKE_C_FLAGS}")

# Assume we will use the built in trusted certificates.
# Many embedded devices will need this.
option(use_sample_trusted_cert "Set flag in samples to use SDK's built-in CA as TrustedCerts" ON)

set(iothub_c_files
        iothub_convenience_sample.c
)

# Conditionally use the SDK trusted certs in the samples (is set to true in cmake toolchain file)
if(${use_sample_trusted_cert})
        add_definitions(-DSET_TRUSTED_CERT_IN_SAMPLES)
        include_directories($ENV{WORK_ROOT}/azure-iot-sdk-c/certs)
        set(iothub_c_files
                ${iothub_c_files}
                $ENV{WORK_ROOT}/azure-iot-sdk-c/certs/certs.c)
endif()

# Set up the include and library paths
include_directories($ENV{QEMU_LD_PREFIX}/usr/include/)
include_directories($ENV{QEMU_LD_PREFIX}/usr/include/azureiot)
link_directories($ENV{QEMU_LD_PREFIX}/usr/lib)

add_executable(azure_exe ${iothub_c_files})

# Redundant in this case but shows how to rename your output executable
set_target_properties(azure_exe PROPERTIES OUTPUT_NAME "azure_exe")

# List the libraries required by the link step
target_link_libraries(azure_exe iothub_client_mqtt_transport iothub_client umqtt aziotsharedutil parson pthread curl ssl crypto m )
```

* myapp/iothub_convenience_sample.c

Use the azure iot c sdk iothub sample file  [iothub_convenience_sample.c](https://github.com/Azure/azure-iot-sdk-c/blob/master/iothub_client/samples/iothub_convenience_sample/iothub_convenience_sample.c). Replace the "connectionString" in the file with your own iothub connectionString.

### Build Docker Image

Run the following command:

```bash
docker build -t dockcross-extended:latest . --network=host
```

Run the image to compile application and get executable binary file.

```bash
CID=$(docker create dockcross-extended)
mkdir my_exe/
docker cp $CID:/work/AzureBuild/myapp/cmake/myapp my_exe/
file my_exe/myapp
```