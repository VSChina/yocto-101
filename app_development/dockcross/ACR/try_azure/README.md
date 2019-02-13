# Usage

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
docker cp $CID:/work/AzureBuild/azureIoT/cmake/azure_exe my_exe/
file my_exe/azure_exe