#!/bin/bash

# Check whether preparation has been made
CHECK_FILE=/usr/bin/.check
if [ -f $CHECK_FILE ]; then
    echo "### Preparation has been done. Skip preparation"
else
    echo "### One-time preparation..."

    # extract toolchain
    echo "### Extract toolchain..."
    cd /usr/xcc && \
        tar xf /usr/xcc/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz && \
        mv /usr/xcc/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu/* /usr/xcc/aarch64-linux-gnu && \
        rm /usr/xcc/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz

    # Build openssl, curl, uuid
    echo "### Build openssl, curl, uuid..."
    cd /work && \
        apk add --no-cache perl && \
        tar -xvf openssl-1.0.2o.tar.gz && \
        cd openssl-1.0.2o && \
        ./Configure linux-generic32 shared --prefix=${QEMU_LD_PREFIX}/usr --openssldir=${QEMU_LD_PREFIX}/usr && \
        make && \
        make install && \
        rm /work/openssl-1.0.2o.tar.gz && \
        rm -rf /work/openssl-1.0.2o && \
        cd .. && \
        tar -xvf curl-7.60.0.tar.gz && \
        cd curl-7.60.0 && \
        ./configure --with-sysroot=${QEMU_LD_PREFIX} --prefix=${QEMU_LD_PREFIX}/usr --target=${CROSS_TRIPLE} --with-ssl --with-zlib --host=${CROSS_TRIPLE} --build=x86_64-pc-linux-uclibc && \
        make && \
        make install && \
        rm /work/curl-7.60.0.tar.gz && \
        rm -rf /work/curl-7.60.0 && \
        cd .. && \
        tar -xvf util-linux-2.32-rc2.tar.gz && \
        cd util-linux-2.32-rc2 && \
        ./configure --prefix=${QEMU_LD_PREFIX}/usr --with-sysroot=${QEMU_LD_PREFIX} --target=${CROSS_TRIPLE} --host=${CROSS_TRIPLE} --disable-all-programs  --disable-bash-completion --enable-libuuid && \
        make && \
        make install && \
        rm /work/util-linux-2.32-rc2.tar.gz && \
        rm -rf /work/util-linux-2.32-rc2 && \
        apk del --no-cache perl
        
    # set up check flag
    touch $CHECK_FILE
fi

echo "## END of launch.sh"
