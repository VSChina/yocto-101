# A Decouple way to develop application

Wrap the azure sdk preparation in a online-host image(`devicedevex.azurecr.io/azure-sdk:latest`). User can focus on the application development part.

Download `devicedevex.azurecr.io/azure-sdk:latest` image directly to save building time.

* [./Dockerfile](./Dockerfile): Dockerfile to build [lindisjtu/dockcross_azure:latest](https://hub.docker.com/r/lindisjtu/dockcross_azure).  
* [./try_azure/](./try_azure): workspace to try building azure related application.  
* [./try_hello/](./try_hello): workspace to try building simple hello-world application.  