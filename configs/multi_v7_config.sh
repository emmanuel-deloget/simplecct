#!/bin/sh

# This sample configuration is suitable to many ARMv7 boards. The used
# kernel configuration is enough to boot the following processors:
#  - Allwinner's A10, A13, A20
#  - Some recent rockchip processors
#  - Marvell's Armada 370, Armada XP
#  - NVIDIA's Tegra 1, 2, 3
#  - TI's Omap 3, Omap 4, Omap 5
#  - Freescale's IMX53, IMX6Q, IMX6SL
# And probably many more (more are added in each new kernel)
#
# The choosen configuration forces the use of the internal FPU and
# is suitable to generate hard-float code using the latest ARM EABI
# (ABI5). It generates code using the musl standard C library
# (see http://musl-libc.org/ for further information).

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

