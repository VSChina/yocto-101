# Host docker images on Azure Container Registry

## Reference

* [Azure Container Registry get started](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal)

## Steps

### create docker image and push to acr

1. Create docker image  
    Create a clean folder as your workspace. Edit a file named *Dockerfile* implements your docker image's logic.  
    Build the image.

    ```bash
    docker build -t azure-sdk:latest .
    ```

    Now you have *azure-sdk:latest* image successfully built on your local.

2. Push image to Container Registry  
    Open a Azure Command Prompt.

    * login  

    ```bash
    az login
    az acr login --name devicedevex  --subscription "IoT DevKit SDK"
    ```

    * push image

    ```bash
    docker tag azure-sdk:latest devicedevex.azurecr.io/azure-sdk:latest
    docker push devicedevex.azurecr.io/azure-sdk:latest
    ```

    * Clean up local image

    ```bash
    docker rmi devicedevex.azurecr.io/azure-sdk:latest
    ```

    On [azure portal](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/c421419d-4d2d-4241-ae5d-ffe431aa4011/resourcegroups/device-devex/providers/Microsoft.ContainerRegistry/registries/devicedevex/repository) you can check that the image has been successfully stored on the repository.

### Pull acr image

1. Get authentication
    * on azure portal, container registry ->> "[Access Keys](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/c421419d-4d2d-4241-ae5d-ffe431aa4011/resourcegroups/device-devex/providers/Microsoft.ContainerRegistry/registries/devicedevex/accessKey)", enable "Admin user" to get **username** and **password**

    * login server

    ```bash
    docker login devicedevex.azurecr.io
    Username: devicedevex
    Password:
    Login Succeeded
    ```

2. Pull and Use ACR Image

    ```bash
    docker run devicedevex.azurecr.io/azure-sdk:latest
    ```
