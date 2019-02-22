# FROM devicedevex.azurecr.io/public/azure-sdk:latest
FROM dockcross/linux-arm64

WORKDIR /work/GPIOBuild
COPY gpio_example.c /work/GPIOBuild/

RUN ${CC} gpio_example.c -o gpio_example
RUN ls -l gpio_example
