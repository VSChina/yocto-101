# Yocto Application development and the Extensible Software Development Kit(eSDK)

## Purpose of this Document

Follow yocto's start-up [instructions](./buildYoctoRpi101.md), we can build a simple image on host machine, which is a win 10 x86-64 PC, and flash the image so it can run on our target machine, which is a [Raspberry Pi3 B+ board](https://www.raspberrypi.org/documentation/hardware/raspberrypi/). After that, we want to develop our own applicatoins on host machine and run the application on target hardware's yocto OS.

Yocto Project uses Software Development Kit(Standard SDK) or Extensible Software Development Kit(eSDK) to help develop applications.

This document first has a brief introduction of the SDK and the SDK development model, then presents two application development walkthroughs: One is the simple helloworld, the other is a sample applicatoin using [Azure iot c sdk](https://github.com/azure/azure-iot-sdk-c).

### References

* Yocto official site: [SDK manual](https://www.yoctoproject.org/docs/2.6/sdk-manual/sdk-manual.html)
* Intel YP Application Development workflow: [Intel manual](http://events17.linuxfoundation.org/sites/events/files/slides/2017%20ELC%20Henry%20Bruce.pdf)
* Azure iot c SDK doc: [Docker SDK Cross Compilation](https://github.com/Azure/azure-iot-sdk-c/blob/master/doc/Docker_SDK_Cross_Compile.md#the-docker-script)

### Platform

* Host machine: Win 10, x86-64 PC
* target machine: Raspberry Pi3 B+

## Introduction of SDK

There are several ways to develop application for yocto project. Both `standard SDK` and `extension SDK` provide a cross-development toolchain and libraries tailored to the contents of a specific image. We leverage SDK to develop code to run on target machine.

Both SDK consist of the following:  

* **Cross-Development Toolchain**: This toolchain contains a compiler, debugger, and various miscellaneous tools.
* **Libraries, Headers, and Symbols**: The libraries, headers, and symbols are specific to the image (i.e. they match the image).
* **Environment Setup Script**: This *.sh file, once run, sets up the cross-development environment by defining variables and preparing for SDK use.

Difference between standard SDK and extensible SDK:

* The Standard SDK: a more traditional toolchain experience.
* The Extensible SDK: a toolchain experience supplemented with the powerful set of `devtool` commands tailored for the Yocto Project environment. (Updateable, Extensible, Packages, Images, Teamwork)
  * Major design change
  * Allows compact installer (as small as 35MB)
  * Updateable and extensible – lazy install
  * Simplifies team-work
  * First appeared in Jethro, usable in Krogoth

The SDK development environment consists of the following:

* The self-contained SDK: an architecture-specific cross-toolchain and matching sysroots (target and native) all built by the OpenEmbedded build system (e.g. the SDK).
* The Quick EMUlator (QEMU)
* The Eclipse IDE Yocto Plug-in
* Performance Enhancing Tools

## SDK Development Model

| ![SDK Development Model](https://www.yoctoproject.org/docs/2.6/sdk-manual/figures/sdk-environment.png) |
|:--:|
| *SDK Development Model* |

### Workflow

1. Install the SDK for your hardware architecture
2. Download or build the target image
3. develop and test your application

## Helloworld Example

1. Build base image

    Choose "raspberrypi3-64" for MACHINE type in conf/local.conf.

    ```bash
    MACHINE = "raspberrypi3-64" // in file conf/local.conf
    ```

    Run `bitbake core-image-base` to get the basic image for raspberrypi. Now this image runs as a 64-bits OS. And rpi3 therefore uses aarch64 instruction sets.

    Run the image on raspberry pi 3, and run the command to check the machine architecture:

    ```shell
    root@raspberrypi3-64: ~# uname -a
    Linux raspberrypi3-64 4.14.79 #1 SMP PREEMPT Tue Dec 18 12:05:19 UTC 2018 aarch64 GNU/Linux
    ```

2. Install eSDK

    For windows host machine, use the [eSDK docker container](https://hub.docker.com/r/crops/extsdk-container).

    According to extsdk-container github [README.md](https://github.com/crops/extsdk-container), Make sure you have go through the instructions: [https://github.com/crops/docker-win-mac-docs/wiki](https://github.com/crops/docker-win-mac-docs/wiki).

    Use the volume called *myvolume* which we have created in the previous step. Run the following command:

    ```bash
    docker run --rm -it -v myvolume:/workdir crops/extsdk-container --url http://someserver/extensible_sdk_installer.sh
    ```

    * --url http://someserver/extensible_sdk_installer.sh: This is the url of the extensible sdk installer. It will automatically be downloaded and prepared to use inside of the workdir. Substitute in the url for whatever extensible sdk installer you want to use.  
        The url can be found on the [toolchain download website](http://downloads.yoctoproject.org/releases/yocto/).  
        Read the [tarball installer name form reference](https://www.yoctoproject.org/docs/2.6/sdk-manual/sdk-manual.html#sdk-installing-the-extensible-sdk) carefully to select the correct SDK installer.

        In this happy path example, we have:
        * Host machine: Windows 10(x86-64 architecture)
        * target machine: Raspberry Pi3 B+ board

            hardware architecture: `aarch64` when ran 64-bits OS(and the CPU is armv8); `armv5e` when ran 32-bits OS(and the CPU "looks like" armv7l architecture)
  
        In our case, we choose `poky-glibc-x86_64-core-image-minimal-aarch64-toolchain-ext-2.6.sh`, where `x86_64` is our build maschine's architecture, `aarch64` is the hardware architecture.

    Run the command and you should see output like this:

    ```bash
    $ docker run --rm -it -v myvolume:/workdir crops/extsdk-container --url http://downloads.yoctoproject.org/releases/yocto/yocto-2.6/toolchain/x86_64/poky-glibc-x86_64-core-image-minimal-aarch64-toolchain-ext-2.6.sh
    Attempting to download http://downloads.yoctoproject.org/releases/yocto/yocto-2.6/toolchain/x86_64/poky-glibc-x86_64-core-image-minimal-aarch64-toolchain-ext-2.6.sh
    ######################################################################## 100.0%
    Poky (Yocto Project Reference Distro) Extensible SDK installer version 2.6
    ==========================================================================
    You are about to install the SDK to "/workdir". Proceed[Y/n]? Y
    Extracting SDK..............done
    Setting it up...
    Extracting buildtools...
    Preparing build system...
    Parsing recipes: 100% |###########################################################################################################################################| Time: 0:01:18
    Initialising tasks: 100% |########################################################################################################################################| Time: 0:00:00
    Checking sstate mirror object availability: 100% |################################################################################################################| Time: 0:00:03
    Loading cache: 100% |#############################################################################################################################################| Time: 0:00:00
    Initialising tasks: 100% |########################################################################################################################################| Time: 0:00:00
    done
    SDK environment now set up; additionally you may now run devtool to perform development tasks.
    Run devtool --help for further details.
    SDK has been successfully set up and is ready to be used.
    Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
    $ . /workdir/environment-setup-aarch64-poky-linux
    SDK environment now set up; additionally you may now run devtool to perform development tasks.
    Run devtool --help for further details.
    sdkuser@aea9920bb018:/workdir$
    ```

    At this point you should be able to use the shell to use the extensible sdk.

    The installed extensible SDK consists of several files and directories. Basically, it contains an SDK environment setup script, some configuration files, an internal build system, and the devtool functionality.

3. Source the SDK Environment Setup Script

    ```bash
    sdkuser@aea9920bb018:/workdir$ source environment-setup-aarch64-poky-linux
    ```

4. Two ways to develop helloworld application

    To develop application, we can either use standard SDK with traditional toolchain experience or use the extensible SDK with the powerful `devtool`.

    * Use the standard SDK

        1. Create a Working Directory and Populate It: Create a clean directory for your project and then make that directory your working location.

            ```bash
            mkdir source
            cd source
            git clone https://github.com/dilin-MS/yocto-example.git
            ```

        2. Create the *configure* Script: Use the *autoreconf* command to generate the *configure* script (The `-i` parameter is for adding missing auxillary files):

            ```bash
            cd yocto-examplle/helloworld
            autoreconf -i
            ```
            The autoreconf tool takes care of running the other Autotools such as aclocal, autoconf, and automake.

        3. Cross-Compile the Project: This command compiles the project using the cross-compiler. The CONFIGURE_FLAGS environment variable provides the minimal arguments for GNU configure:

            ```bash
            ./configure ${CONFIGURE_FLAGS}
            ```

            For an Autotools-based project, you can use the cross-toolchain by just passing the appropriate host option to *configure.sh*.

            ```bash
            $ echo ${CC}
            aarch64-poky-linux-gcc --sysroot=/workdir/tmp/sysroots/qemuarm64
            $ ./configure --host=aarch64-poky-linux
            ```

        4. Make and Install the Project

            ```bash
            make
            make install DESTDIR=./tmp
            ```

            This next command is a simple way to verify the installation of your project. Running the command prints the architecture on which the binary file can run. This architecture should be the same architecture that the installed cross-toolchain supports.

            ```bash
            $ file ./tmp/usr/local/bin/hello
            tmp/usr/local/bin/hello: ELF 64-bit LSB shared object, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.14.0, BuildID[sha1]=0b82e9e68df735e855a8fe23e8b4202a2aac8a4f, not stripped
            ```

        5. Excute Your Project: Move the hello binary file to your hardware. Excute the binary executable file.

            ```bash
            ./tmp/usr/local/bin/hello
            ```

            The project prints "Hello world!" message.

    * Use the extensible SDK

## Simple Azure IoT Application

We will develop a azure iot sample application on a clean machine, compile the application using cross-compilation toolchain, and deploy the executable application file to our hardware, which is running a yocto image.

Our target architecture is aarch64. We leverage the above extsdk-container and add some detailed instructions.

On our host machine, create a clean directory with a Dockerfile and a folder named *myapp*/:  

```bash
.
├── Dockerfile  
└── myapp
    ├── CMakeLists.txt
    └── iothub_convenience_sample.c
```

1. Edit Files

    * Dockerfile

        ```bash
        From crops/yocto:ubuntu-16.04-base

        # Run commands that require root authority
        USER root

        # Fetch and install all outstanding updates
        RUN apt-get update && apt-get -y upgrade

        # Install cmake, git, wget and nano
        RUN apt-get install -y cmake git wget nano curl

        RUN mkdir /workdir
        RUN chown -R 1000:1000 /workdir

        # setup new user builder so that we don't run it all as root
        RUN groupadd -o -g $(stat -c "%g" /workdir) "builder"
        RUN useradd -N -g $(stat -c "%g" /workdir) -m -o -u $(stat -c "%u" /workdir) -p builder "builder"
        USER builder

        # Download yocto esdk-container
        WORKDIR /workdir
        RUN curl -# -o esdk_install.sh http://downloads.yoctoproject.org/releases/yocto/yocto-2.6/toolchain/x86_64/poky-glibc-x86_64-core-image-minimal-aarch64-toolchain-ext-2.6.sh

        # setup sdk
        RUN chmod 777 ./esdk_install.sh
        RUN /bin/bash -c "/workdir/esdk_install.sh -d /workdir -y"

        # Create a work directory and switch to it
        RUN mkdir AzureBuild
        WORKDIR AzureBuild

        # Download the Azure IoT SDK for C
        RUN git clone --recursive https://github.com/azure/azure-iot-sdk-c.git

        # Download OpenSSL source and expand it
        RUN wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz
        RUN tar -xvf openssl-1.0.2o.tar.gz

        # Download cURL source and expand it
        RUN wget http://curl.haxx.se/download/curl-7.60.0.tar.gz
        RUN tar -xvf curl-7.60.0.tar.gz

        # Download the Linux utilities for libuuid and expand it
        RUN wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32-rc2.tar.gz
        RUN tar -xvf util-linux-2.32-rc2.tar.gz

        # Set up environment variables in preparation for the builds to follow
        ENV SDKTARGETSYSROOT=/workdir/tmp/sysroots/qemuarm64
        ENV PATH=/workdir/tmp/sysroots/x86_64/usr/bin:/workdir/tmp/sysroots/x86_64/usr/sbin:/workdir/tmp/sysroots/x86_64/bin:/workdir/tmp/sysroots/x86_64/sbin:/workdir/tmp/sysroots/x86_64/usr/bin/../x86_64-pokysdk-linux/bin:/workdir/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux:/workdir/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux-musl:$PATH
        ENV CC="aarch64-poky-linux-gcc  --sysroot=$SDKTARGETSYSROOT"
        ENV AS="aarch64-poky-linux-as "
        ENV AR=aarch64-poky-linux-ar
        ENV NM=aarch64-poky-linux-nm
        ENV RANLIB=aarch64-poky-linux-ranlib
        ENV LD="aarch64-poky-linux-ld  --sysroot=$SDKTARGETSYSROOT"
        ENV LDFLAGS="-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed"

        ENV WORK_ROOT=/workdir/AzureBuild
        ENV TOOLCHAIN_PREFIX=${SDKTARGETSYSROOT}/usr
        ENV TOOLCHAIN_NAME=aarch64-poky-linux

        # Build OpenSSL
        WORKDIR openssl-1.0.2o
        RUN ./Configure linux-aarch64 shared --prefix=${TOOLCHAIN_PREFIX} --openssldir=${TOOLCHAIN_PREFIX}
        RUN make
        RUN make install
        WORKDIR ..

        # Build cURL
        WORKDIR curl-7.60.0
        RUN ./configure --with-sysroot=${SDKTARGETSYSROOT} --prefix=${TOOLCHAIN_PREFIX} --target=${TOOLCHAIN_NAME} --with-ssl --with-zlib --host=${TOOLCHAIN_NAME} --build=x86_64-pc-linux-uclibc
        RUN make
        RUN make install
        WORKDIR ..

        # Build uuid
        WORKDIR util-linux-2.32-rc2
        RUN ./configure --prefix=${TOOLCHAIN_PREFIX} --with-sysroot=${SDKTARGETSYSROOT} --target=${TOOLCHAIN_NAME} --host=${TOOLCHAIN_NAME} --disable-all-programs  --disable-bash-completion --enable-libuuid
        RUN make
        RUN make install
        WORKDIR ..

        # To build the SDK we need to create a cmake toolchain file. This tells cmake to use the tools in the toolchain rather than those on the host
        WORKDIR azure-iot-sdk-c

        # Create a working directory for the cmake operations
        RUN mkdir cmake
        WORKDIR cmake

        # Create a cmake toolchain file on the fly
        RUN echo "SET(CMAKE_SYSTEM_NAME Linux)     # this one is important" > toolchain.cmake
        RUN echo "SET(CMAKE_SYSTEM_VERSION 1)      # this one not so much" >> toolchain.cmake
        RUN echo "SET(CMAKE_SYSROOT ${SDKTARGETSYSROOT})" >> toolchain.cmake
        RUN echo "SET(CMAKE_C_COMPILER ${CC})" >> toolchain.cmake
        RUN echo "SET(CMAKE_CXX_COMPILER ${CXX})" >> toolchain.cmake
        RUN echo "SET(CMAKE_FIND_ROOT_PATH ${SDKTARGETSYSROOT})" >> toolchain.cmake
        RUN echo "SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
        RUN echo "SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
        RUN echo "SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake
        RUN echo "SET(set_trusted_cert_in_samples true CACHE BOOL \"Force use of TrustedCerts option\" FORCE)" >> toolchain.cmake

        # Build the SDK. This will use the OpenSSL, cURL and uuid binaries that we built before
        RUN cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DCMAKE_INSTALL_PREFIX=${TOOLCHAIN_PREFIX} ..
        RUN make
        RUN make install

        # Finally a sanity check to make sure the files are there
        RUN ls -al ${TOOLCHAIN_PREFIX}/lib
        RUN ls -al ${TOOLCHAIN_PREFIX}/include

        # Go to project root
        WORKDIR ../..

        # Build your Azure application
        # Copy a directory from the host containing the files to build setting ownership at the same time
        ADD --chown=builder:builder myapp  ${WORK_ROOT}/myapp

        # Sanity check
        RUN ls -al myapp

        # Switch to application directory
        WORKDIR myapp

        # Create and switch to cmake directory
        RUN mkdir cmake
        WORKDIR cmake

        # Generate the makefiles with the same toolchain file and build
        RUN cmake -DCMAKE_TOOLCHAIN_FILE=${WORK_ROOT}/azure-iot-sdk-c/cmake/toolchain.cmake ..
        RUN make

        # There should be an executable called myapp
        RUN ls -al myapp
        ```

    * myapp/CmakeLists.txt

        ```bash
        cmake_minimum_required(VERSION 2.8.11)
        project(myapp_project)

        # The demonstration uses C99 but it could just as easily be a C++ application
        set (CMAKE_C_FLAGS "--std=c99 ${CMAKE_C_FLAGS}")

        # Assume we will use the built in trusted certificates.
        # Many embedded devices will need this.
        option(use_sample_trusted_cert "Set flag in samples to use SDK's built-in CA as TrustedCerts" ON)

        set(iothub_c_files
                iothub_convenience_sample.c
        )

        # Conditionally use the SDK trusted certs in the samples (is set to true in cmake toolchain file)
        if(${use_sample_trusted_cert})
                add_definitions(-DSET_TRUSTED_CERT_IN_SAMPLES)
                include_directories($ENV{WORK_ROOT}/azure-iot-sdk-c/certs)
                set(iothub_c_files
                        ${iothub_c_files}
                        $ENV{WORK_ROOT}/azure-iot-sdk-c/certs/certs.c)
        endif()

        # Set up the include and library paths
        include_directories($ENV{TOOLCHAIN_PREFIX}/include/)
        include_directories($ENV{TOOLCHAIN_PREFIX}/include/azureiot)
        link_directories($ENV{TOOLCHAIN_PREFIX}/lib)

        add_executable(myapp ${iothub_c_files})

        # Redundant in this case but shows how to rename your output executable
        set_target_properties(myapp PROPERTIES OUTPUT_NAME "myapp")

        # List the libraries required by the link step
        target_link_libraries(myapp iothub_client_mqtt_transport iothub_client umqtt aziotsharedutil parson pthread curl ssl crypto m )
        ```
    * myapp/iothub_convenience_sample.c

        Use the azure iot c sdk iothub sample file [iothub_convenience_sample.c](https://github.com/Azure/azure-iot-sdk-c/blob/master/iothub_client/samples/iothub_convenience_sample/iothub_convenience_sample.c). Replace the "connectionString" in the file with your own iothub connectionString.

2. Build New Docker Image

    ```bash
    docker build -t azurebuild:latest . --network=host
    ```
    You can replace the value 'azurebuild' with any name that describes your build.

3. Build Your Application

    ```bash
    docker volume create --name azure-volume
    docker run -it --rm -v azure-volume:/workdir busybox chown -R 1000:1000 /workdir
    docker run --rm -it -v azure-volume:/workdir azurebuild:latest
    ```

    Then there will be a executable file named "myapp" under your container's /workdir/AzureBuild/myapp/cmake directory:

    ```bash
    yoctouser@d868a2aef07b:/workdir/AzureBuild/myapp/cmake$ ls
    CMakeCache.txt  CMakeFiles  Makefile  cmake_install.cmake  myapp
    ```

4. Copy the Executable File from the Docker Container

    Find out the name or container ID of your docker container.

    ```bash
    $ docker container ls
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
    d868a2aef07b        azurebuild:latest   "/bin/sh -c /bin/bash"   About a minute ago   Up 34 seconds                           naughty_nash
    ```

    Copy the executable file from docker container to your host machine.

    ```bash
    docker cp naughty_nash:/workdir/AzureBuild/myapp/cmake/myapp my_app_exe/
    ```

    Run the `file` command to check the executable file:

    ```bash
    file myapp
    myapp: ELF 64-bit LSB shared object ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.14.0, BuildID[sha1]=a001060cff933417f3b70c3525d5c2b88e2ba48e, with debug_info, not stripped
    ```

    Copy the myapp executable file and library your device needed to your target hardware, and the sample executable file should run smoothly on your target hardware:

    ```bash
    root@raspberrypi3-64:~/dilin/my-sample-application# ./myapp

    This sample will send messages continuously and accept C2D messages.
    Press Ctrl+C to terminate the sample.

    Creating IoTHub handle

    Sending message 1 to IoTHub
    Message: {"temperature":33.155,"humidity":73.982,"scale":"Celcius"}
    The device client is connected to iothub
    Confirmation callback received for message 1 with result IOTHUB_CLIENT_CONFIRMATION_OK

    Sending message 2 to IoTHub
    Message: {"temperature":32.385,"humidity":64.992,"scale":"Celcius"}
    Confirmation callback received for message 2 with result IOTHUB_CLIENT_CONFIRMATION_OK

    Sending message 3 to IoTHub
    Message: {"temperature":24.594,"humidity":63.516,"scale":"Celcius"}
    Confirmation callback received for message 3 with result IOTHUB_CLIENT_CONFIRMATION_OK

    ```
    **Note**: Depending upon your device you may need to copy additional binaries from the container in order to add them to your device. For example you device may not have the OpenSSL binaries so you will need to copy `libssl.so` and `libcrypto.so`. This could also be true for libuuid and libcurl. All of these libraries will be in the toolchain.

## Troubleshooting

* If the application binary cannot run on target machine, and you get:

    ```bash
    cannot execute binary: Exec format error
    ```

    You may have chose a wrong target for your cross-compilation toolchain. Make sure your target hardware architecture is aarch64 if you use `aarch64-poky-linux` cross-compiler.

* Cannot open shared object file, Error 40

    As mentioned above, we may need to copy needed binaries to get the myapp be able to run on target machine. If you run `./myapp` on target machine and get:

    ```shell
    root@raspberrypi3-64:~/dilin/my-sample-application# ./myapp
    ./myapp: error while loading shared libraries: libssl.so.1.0.0: cannot open shared object file: Error 40
    ```

    This indicates the missing binary. Copy from docker container the corresponding binary( you can use `find` command to locate the binary file in docker container) and place it under the same application directory on target machine. Then the application directory looks like:

    ```bash
    root@raspberrypi3-64:~/dilin/my-sample-application# ls
    libcrypto.so.1.0.0  libssl.so.1.0.0     myapp
    ```

    Create symbolic link for these needed binaries. Remember to use full path.

    ```bash
    root@raspberrypi3-64:~/dilin/my-sample-application# ln -s /home/root/dilin/my-sample-application/libcrypto.so.1.0.0 /usr/lib/libcrypto.so.1.0.0
    root@raspberrypi3-64:~/dilin# ls -l /usr/lib/libcrypto.so.1.0.0
    lrwxrwxrwx    1 root     root            35 Dec 23 08:36 /usr/lib/libcrypto.so.1.0.0 -> /home/root/dilin/my-sample-application/libcrypto.so.1.0.0
    ```

* Cannot open shared object file: No such file or directory

    ```shell
    root@raspberrypi3-64:~/dilin/my-sample-application# ./myapp
    ./myapp: error while loading shared libraries: libssl.so.1.0.0: cannot open shared object file: No such file or directory
    ```

    In this situation, try installing coresponding libraries on target machine's image. Assume this error message ocurrs for libssl, libcurl and libcrpto. Method is as follow.

    (1) Edit conf/local.conf on your yocto image build machine:

    ```bash
    EXTRA_IMAGE_FEATURES ?= "debug-tweaks ssh-server-openssh"
    IMAGE_INSTALL_append = " packagegroup-core-ssh-openssh openssh-sftp-server openssl10 libssl10 libcrypto curl libcurl zlib"
    ```

    The above setting installs libssl, libcurl and libcrypto.

    (2) Bitbake Image.

    (3) Modify libraries to meet version requirement.

    Run the new image on target machine, check the libraries not found when executating myapp. For example, if you have `libssl.so.1.0.2` under target machine's `/usr/lib/` directory, but error message indicate `libssl.1.0.0` is needed. Run the following command on target machine.

    ```bash
    root@raspberrypi3-64:/usr/lib# ln -s libssl.so.1.0.2 libssl.so.1.0.0
    ```

    In this way, the application can find its needed shared libraries.