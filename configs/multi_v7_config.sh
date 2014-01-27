#!/bin/sh

# ======================================================================
#
# simplecct: a series of scripts to build cross-compilation toolchains
# Copyright (C) 2014 Emmanuel Delogte
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# ======================================================================

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

# GMP version is quite free ; the other versions are more or less
# imposed by the select version of gcc
GMP_VERSION=5.1.3
MPFR_VERSION=3.1.2
MPC_VERSION=1.0.1
GCC_VERSION=4.8.2

# the latest binutils should work
BINUTILS_VERSION=2.24

# we are using the latest kernel to build our toolchain
LINUX_VERSION=3.13

# a new breed of kernel headers
SABOTAGE_KH_VERSION=3.12.6-1

# we are able to compile busybox
BUSYBOX_VERSION=1.22.1

# we are basing this toolchain on musl
LIBC_NAME=musl
LIBC_VERSION=0.9.15
LIBC_URL=http://www.musl-libc.org/releases/musl-0.9.15.tar.gz

# linux need these to select the right kernel headers
LINUX_ARCH=arm
LINUX_DEF_CONFIG=multi_v7_defconfig

# specific gcc configure options for both stage1 and stage2
GCC_S1_CONFIGURE_ARGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
GCC_S2_CONFIGURE_ARGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"

