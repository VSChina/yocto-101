# Use YP Extensible Software Development Kit(eSDK) to develop application

For windows host machine, use the [eSDK docker container](https://hub.docker.com/r/crops/extsdk-container).

1. Install eSDK

    According to extsdk-container github [README.md](https://github.com/crops/extsdk-container), Make sure you have go through the instructions: https://github.com/crops/docker-win-mac-docs/wiki.

    Use the volume called *myvolume* which we have created in the previous step. Run the following command:
    ```bash
    docker run --rm -it -v myvolume:/workdir crops/extsdk-container --url http://someserver/extensible_sdk_installer.sh
    ```

    * --url http://someserver/extensible_sdk_installer.sh: This is the url of the extensible sdk installer. It will automatically be downloaded and prepared to use inside of the workdir. Substitute in the url for whatever extensible sdk installer you want to use.  
    The url can be found on the [toolchain download website](http://downloads.yoctoproject.org/releases/yocto/).  
    Find the proper SDK installer, for example: 
    http://downloads.yoctoproject.org/releases/yocto/yocto-2.6/toolchain/x86_64/poky-glibc-x86_64-core-image-minimal-aarch64-toolchain-ext-2.6.sh

    Run the command and you should see output like this:
    ```bash
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
    sdkuser@7ae4b3d72b14:/workdir$
    ```
    At this point you should be able to use the shell to use the extensible sdk.

    The installed extensible SDK consists of several files and directories. Basically, it contains an SDK environment setup script, some configuration files, an internal build system, and the devtool functionality.

2. Add helloworld recipe using devtool

    Run the following command under /wordir.
    ```bash
    sdkuser@7ae4b3d72b14:/workdir$ . environment-setup-aarch64-poky-linux
    sdkuser@7ae4b3d72b14:/workdir$ devtool add https://github.com/dilin-MS/yocto-example.git
    ```

    Output:
    ```bash
    NOTE: Starting bitbake server...
    ImportError: No module named site
    OpenEmbedded requires 'python' to be python v2 (>= 2.7.3), not python v3.
    Please upgrade your python v2.
    NOTE: Starting bitbake server...
    NOTE: Fetching git://github.com/dilin-MS/yocto-example.git;protocol=https...
    Loading cache: 100% |############################################################################################################################################| Time: 0:00:04
    Loaded 1263 entries from dependency cache.
    Parsing recipes: 100% |##########################################################################################################################################| Time: 0:00:00
    Parsing of 791 .bb files complete (790 cached, 1 parsed). 1264 targets, 59 skipped, 0 masked, 0 errors.
    NOTE: Resolving any missing task queue dependencies
    Initialising tasks: 100% |#######################################################################################################################################| Time: 0:00:00
    NOTE: Executing RunQueue Tasks
    NOTE: Tasks Summary: Attempted 2 tasks of which 0 didn't need to be rerun and all succeeded.
    NOTE: Using default source tree path /workdir/workspace/sources/yocto-example
    NOTE: Starting bitbake server...
    NOTE: Using source tree as build directory since that would be the default for this recipe
    NOTE: Recipe /workdir/workspace/recipes/yocto-example/yocto-example_git.bb has been automatically created; further editing may be required to make it fully functional
    ```
 
 
 
 
 
 
 
 


1.1 [downloading an SDK](http://downloads.yoctoproject.org/releases/yocto/yocto-2.6/toolchain/x86_64/)

download: 

1.2 build the SDK installer(https://www.yoctoproject.org/docs/2.6/sdk-manual/sdk-manual.html#sdk-building-an-sdk-installer)
