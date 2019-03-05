FROM devicedevex.azurecr.io/alpine-azure-sdk:latest

COPY azureIoT /work/azure-iot-sdk-c/azureIoT

# Add user app into CMake build structure
RUN echo "add_subdirectory(azureIoT)" >> /work/azure-iot-sdk-c/CMakeLists.txt

WORKDIR /work/azure-iot-sdk-c

RUN apk add --no-cache cmake make && \
    mkdir cmake && \
    cd cmake && \
    cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .. && \
    make

RUN find . -name azure_exe
# binary file can be found in /work/AzureBuild/azure-iot-sdk-c/cmake/azureIoT/azure_exe
