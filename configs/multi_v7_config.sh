#!/bin/sh

TARGET="armeb-linux-musleabihf"

GMP_VERSION=5.1.3
MPFR_VERSION=3.1.2
MPC_VERSION=1.0.1
BINUTILS_VERSION=2.24
GCC_VERSION=4.8.2
LINUX_VERSION=3.13
BUSYBOX_VERSION=1.22.0

LIBC_NAME=musl
LIBC_VERSION=0.9.15
LIBC_URL=http://www.musl-libc.org/releases/musl-0.9.15.tar.gz

LINUX_ARCH=arm
LINUX_DEF_CONFIG=multi_v7_defconfig

GCC_S1_CONFIGURE_ARGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
GCC_S2_CONFIGURE_ARGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"

