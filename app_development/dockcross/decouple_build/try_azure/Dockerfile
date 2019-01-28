FROM lindisjtu/dockcross_azure:latest

WORKDIR /work/AzureBuild
COPY azureIoT  /work/AzureBuild/azureIoT

RUN ls -al azureIoT && \
    cd azureIoT && \
    mkdir cmake && \
    cd cmake && \
    cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .. && \
    make && \
    ls -al azure_exe