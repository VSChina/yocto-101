#!/bin/bash

set -e

if [ $# -lt 2 ]; then
	echo "Usage: ./compile.sh <myapp.c> <output_dir> <dockcross-toolchain-bin>"
	echo "Example: ./compile.sh hello.c ."
	echo "	Or"
	echo "	./compile.sh hello.c . dockcross-linux-armv7"
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

