# Develop Application with Dockcross Toolchain

## Background

Say we have a target machine running yocto image, we are going to develop an application and run on that target machine in the next step. We can choose Yocto's toolchain, yocto esdk, to develop application( see [esdk](../esdk.md)). We can also try the [dockcross](https://github.com/dockcross/dockcross) to complete this work.

Dockcross is several cross-compile toolchains in Docker images developed and maintained by several personal IT programmers.

## Build a Hello-world Application

Create a work directory `hello-world`, which folder structure is as follow.

```bash
.
├── compile.sh
├── my_app
│   └── hello
│       └── hello.c
└── my_exe
```

`compile.sh`

```bash
#!/bin/bash

set -e

if [ $# -lt 2 ]; then
        echo "Usage: ./compile.sh <myapp.c> <output_dir> <dockcross-toolchain-bin>"
        echo "Example: ./compile.sh hello.c ."
        echo "  Or"
        echo "  ./compile.sh hello.c . dockcross-linux-armv7"
        exit 1
elif [ ! -f $1 ]; then
        echo "The input file does not exist!"
        exit 1
elif [ ! -d $2 ]; then
        mkdir -p $2
fi

myapp=$1
output_dir=$2
dockcross_exe={$3:-"dockcross-linux-arm64"}

filename=$(basename $myapp)
myapp_binary="${filename%.*}"

dockcross_exe="dockcross-linux-arm64"
$dockcross_exe bash -c '$CC '${myapp}' -o '${output_dir}/${myapp_binary}''

```

`hello.c`

```bash
#include <stdio.h>

int main(int argc, char *argv[])
{
  printf("Hello cross-compilation world!\n");
  return 0;
}
```

Run the following command to get a wanted cross-compile toolchain.

```bash
docker run --rm dockcross/linux-arm64 >./dockcross-linux-arm64
PATH=${PWD}:$PATH
```

Compile file to get a executable binary, which can run on target machine. Use the command `file` to check the binary's file information.

```bash
sh ./compile.sh hello.c my_exe/
file my_exe/hello
```

Copy the `hello` binary file to raspberry pi target machine, and test the executable file.

## Build an Azure IoT Application
