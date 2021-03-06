#!/bin/sh -e
VER=3.0
test -e linux-$VER.tar.bz2 || wget -c http://www.kernel.org/pub/linux/kernel/v3.0/linux-$VER.tar.bz2
rm -rf linux-$VER;tar -xf linux-$VER.tar.bz2
cd linux-$VER

cat ../linux-noperl-capflags.patch ../linux-noperl-headers.patch \
    ../linux-noperl-timeconst.patch ../linux-posix-sed.patch | patch -p1

make allnoconfig HOSTCFLAGS="-D_GNU_SOURCE" KCONFIG_ALLCONFIG=../linux.config

make HOSTCFLAGS=-D_GNU_SOURCE INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
mkdir -p $R/include/
cp -rv dest/include/* $R/include/

make HOSTCFLAGS=-D_GNU_SOURCE
make INSTALL_MOD_PATH=$R modules_install

mkdir -p $R/boot
cp System.map $R/boot/
cp arch/x86/boot/bzImage $R/boot/vmlinuz-$VER

cd ..
rm -rf linux-$VER
