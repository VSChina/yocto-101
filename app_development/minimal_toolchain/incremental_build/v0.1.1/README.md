
# Version Control 0.1.1

1. Incremental Build
2. Add Version Control: sdk version; base image version; gcc version

* devicedevex.azurecr.io/linux-arm64:0.1.1

    1. Version control - base image: frolvlad/alpine-glibc:glibc-2.28
    2. Download cross-compile toolchain but do not extract

* devicedevex.azurecr.io/azure-sdk-pnp:0.1.1

    1. Download and build Azure SDK dependencies: openssl, curl, uuid
    2. Download and build Azure-sdk-pnp(private-preview)
    3. Entrypoint to run one time work: Extract toolchain, build dependencies, build azure-sdk-pnp

* azure-app:0.1.1

    1. Copy local application file and CMakeLists.txt to workspace
    2. Incremental build application