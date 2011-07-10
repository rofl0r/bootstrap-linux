#!/bin/sh -e
VER=2.6.38.2
test -e linux-$VER.tar.bz2 || wget -c http://www.kernel.org/pub/linux/kernel/v2.6/linux-$VER.tar.bz2
rm -rf linux-$VER;tar -xf linux-$VER.tar.bz2
cd linux-$VER
cp ../linux.config .config

make HOSTCFLAGS=-D_GNU_SOURCE INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
mkdir -p $HOME/local/stow/musl-linux-headers-$VER/x86_64-pc-linux-musl/include/
cp -rv dest/include/* $R/include/

make HOSTCFLAGS=-D_GNU_SOURCE
make INSTALL_MOD_PATH=$R modules_install

mkdir -p $R/boot
cp System.map $R/boot/
cp arch/x86/boot/bzImage $R/boot/vmlinuz-$VER

cd ..
rm -rf linux-$VER