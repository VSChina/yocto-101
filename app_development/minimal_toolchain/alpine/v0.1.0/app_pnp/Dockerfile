FROM devicedevex.azurecr.io/azure-sdk-pnp:0.1.0

COPY azureIoT /work/azure-iot-sdk-c-pnp/azureIoT

# Add user app into CMake build structure
RUN echo "add_subdirectory(azureIoT)" >> /work/azure-iot-sdk-c-pnp/CMakeLists.txt

WORKDIR /work/azure-iot-sdk-c-pnp/cmake

RUN cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .. -Duse_prov_client=ON -Dhsm_type_symm_key:BOOL=ON
RUN make

RUN find . -name azure_exe
# binary file can be found in /work/AzureBuild/azure-iot-sdk-c/cmake/azureIoT/azure_exe
