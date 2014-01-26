#!/bin/sh

. config.sh

__download_and_untar gmp-${GMP_VERSION} http://mirror.anl.gov/pub/gnu/gmp/gmp-${GMP_VERSION}.tar.xz
__download_and_untar mpfr-${MPFR_VERSION} http://www.mpfr.org/mpfr-current/mpfr-${MPFR_VERSION}.tar.bz2
__download_and_untar mpc-${MPC_VERSION} http://www.multiprecision.org/mpc/download/mpc-${MPC_VERSION}.tar.gz
__download_and_untar binutils-${BINUTILS_VERSION} http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2
__download_and_untar gcc-${GCC_VERSION} http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
__download_and_untar linux-${LINUX_VERSION} https://www.kernel.org/pub/linux/kernel/v3.x/linux-${LINUX_VERSION}.tar.xz
__download_and_untar ${LIBC_NAME}-${LIBC_VERSION} ${LIBC_URL}
__download_and_untar busybox-${BUSYBOX_VERSION} http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
