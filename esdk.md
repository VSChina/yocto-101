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


## Troubleshooting

* If the application binary cannot run on target machine, and you get:

    ```bash
    cannot execute binary: Exec format error
    ```

    You may have chose a wrong target for your cross-compilation toolchain. Make your target hardware architecture is aarch64 if you use `aarch64-poky-linux` cross-compiler.
