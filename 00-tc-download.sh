#!/bin/sh

# ======================================================================
#
# simplecct: a series of scripts to build cross-compilation toolchains
# Copyright (C) 2014 Emmanuel Deloget
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

. config.sh

__download_and_untar gmp-${GMP_VERSION} http://mirror.anl.gov/pub/gnu/gmp/gmp-${GMP_VERSION}.tar.xz
__download_and_untar mpfr-${MPFR_VERSION} http://www.mpfr.org/mpfr-current/mpfr-${MPFR_VERSION}.tar.bz2
__download_and_untar mpc-${MPC_VERSION} http://www.multiprecision.org/mpc/download/mpc-${MPC_VERSION}.tar.gz
__download_and_untar binutils-${BINUTILS_VERSION} http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2
__download_and_untar gcc-${GCC_VERSION} http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
__download_and_untar linux-${LINUX_VERSION} https://www.kernel.org/pub/linux/kernel/v3.x/linux-${LINUX_VERSION}.tar.xz
__download_and_untar ${LIBC_NAME}-${LIBC_VERSION} ${LIBC_URL}
__download_and_untar busybox-${BUSYBOX_VERSION} http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2

if [ -n "${SABOTAGE_KH_VERSION}" ]; then
	# these are needed to successfully compile busybox
	__download_and_untar kernel-headers-${SABOTAGE_KH_VERSION} \
		https://github.com/sabotage-linux/kernel-headers/archive/v${SABOTAGE_KH_VERSION}.tar.gz \
		kernel-headers-${SABOTAGE_KH_VERSION}.tar.gz
fi

if [ -n "${UBOOT_VERSION}" ]; then
	case ${TARGET} in
	arm*)
		__download_and_untar u-boot-${UBOOT_VERSION} ftp://ftp.denx.de/pub/u-boot/u-boot-${UBOOT_VERSION}.tar.bz2
		;;
	esac
fi
