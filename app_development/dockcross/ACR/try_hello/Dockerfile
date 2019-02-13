FROM lindisjtu/dockcross_azure:latest

WORKDIR /work/AzureBuild
COPY hello  /work/AzureBuild/hello

RUN ls -al hello && \
    cd hello && \
    ${CC} hello.c -o hello_exe 