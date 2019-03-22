
# Version Control 0.1.0

* devicedevex.azurecr.io/linux-arm64:0.1.0

    1. Use frolvlad/alpine-glibc as base image.
    2. Download and Extract linaro cross-compile toolchain.
    3. Set Environment variable.

* devicedevex.azurecr.io/azure-sdk:0.1.0

    1. Download and build Azure SDK dependencies: openssl, curl, uuid
    2. Download and build Azure SDK

* devicedevex.azurecr.io/azure-app:0.1.0

    1. Copy local application file and CMakeLists.txt to workspace
    2. Incremental build application