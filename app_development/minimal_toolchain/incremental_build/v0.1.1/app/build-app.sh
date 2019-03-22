#!/bin/bash
/bin/bash /usr/bin/launch.sh

# Add workspace to Azure Cmake Structure
APP_BUILD_DIR=/work/azure-iot-sdk-c-pnp/cmake/azureIoT
if [ ! -d "${APP_BUILD_DIR}" ]; then
    echo "## First build time"
    echo "add_subdirectory(azureIoT)" >> /work/azure-iot-sdk-c-pnp/CMakeLists.txt
    mkdir /work/azure-iot-sdk-c-pnp/cmake
else
    echo "## Second build time"
    rm 
fi

# Compile 
cd /work/azure-iot-sdk-c-pnp/cmake && \
    cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .. -Duse_prov_client=ON -Dhsm_type_symm_key:BOOL=ON && \
    make
