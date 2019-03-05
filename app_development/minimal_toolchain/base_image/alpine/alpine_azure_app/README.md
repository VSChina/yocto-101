## Introduction

`try_azure` folder is a azure-related(without pnp) application.  
User place their azure-related application inside `azureIoT` directory, modify `CMakeLists.txt` file. Then follow the below procedures to build their application. The docker container compile the application with the azure ask. Finally, in this example, we get an executable binary file named `azure_exe`.

## Usage

```bash
# authentication
$ docker login devicedevex.azurecr.io
Username: devicedevex
Password:
Login Succeeded

# Build azure app-dev image
cd try-azure
docker build -t azure-test-app:latest .

# copy app binary to local
CID=$(docker create azure-test-app:latest)
mkdir my_exe/
docker cp $CID:/work/AzureBuild/azure-iot-sdk-c/cmake/azureIoT/azure_exe my_exe/
file my_exe/azure_exe