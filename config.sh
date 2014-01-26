#!/bin/sh

TARGET="armeb-linux-musleabi"
LANG=C

TOPDIR=$(pwd)
DLDIR=${TOPDIR}/.download
BUILDDIR=${TOPDIR}/.build/${TARGET}
SRCDIR=${TOPDIR}/.source
STAGINGDIR=${TOPDIR}/staging/${TARGET}
PATCHDIR=${TOPDIR}/patches

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

SYSROOT=${STAGINGDIR}
LINUX_ARCH=arm
LINUX_DEF_CONFIG=multi_v7_defconfig

GCC_S1_CONFIGURE_ARGS=
GCC_S2_CONFIGURE_ARGS=

error() {
	echo $1 1>&2
	exit 1
}

__configure() {
	local product=${1}
	shift

	if [ ! -f ${SRCDIR}/${product}/configure ]; then
		error "product <${product}> has no configure script"
	fi

	rm -rf ${BUILDDIR}/${product}
	mkdir -p ${BUILDDIR}/${product}
	(
		cd ${BUILDDIR}/${product}
		${SRCDIR}/${product}/configure "$@" || {
			error "configuration of <${product}> failed"
		}
	)
}

__untar() {
	local product=${1}
	local dest=${2}

	local file=$(find ${DLDIR} -name "${product}.*" | head -n 1)

	echo "decompressing <${file}> to <${dest}>"

	mkdir -p ${dest}
	tar xf ${file} --strip-components=1 -C ${dest} || {
		error "cannot extract <${file}> to <${dest}>"
	}
}

__download_and_untar() {
	local product=${1}
	local url=${2}
	local file=$(basename ${url})

	if [ ! -f ${DLDIR}/${file} ]; then
		wget ${url} -O ${DLDIR}/${file} || error "cannot download <${url}>"
	fi
	rm -rf ${SRCDIR}/${product}
	mkdir ${SRCDIR}/${product}
	echo "decompressing <${DLDIR}/${file}> to <${SRCDIR}/${product}>"
	tar xf ${DLDIR}/${file} --strip-components=1 -C ${SRCDIR}/${product} || {
		error "cannot extract <${url}> to <${SRCDIR}/${product}>"
	}
}

__patch() {
	set -x
	local base=${1}
	local dest=${2}

	if ! which quilt; then
		error "quilt is not installed on the system"
	fi

	if [ -z "${dest}" ]; then
		dest=${base}
	fi

	if [ -d ${PATCHDIR}/${base} ]; then
		mkdir ${SRCDIR}/${dest}/patches
		cp ${PATCHDIR}/${base}/*.patch ${SRCDIR}/${dest}/patches/
		(
			cd ${SRCDIR}/${dest}/patches/
			ls -1 *.patch > series
			cd ${SRCDIR}/${dest}
			quilt push -a
		)
	fi

	if [ ! -d ${SRCDIR}/${dest}/.pc ]; then
		error "no patch were applied in <${SRCDIR}/${dest}>"
	fi
}

__prepare_gcc() {
	local product=${1}

	if [ ! -f  ${SRCDIR}/gcc-build/.prepared ]; then
		mkdir -p ${SRCDIR}/gcc-build
		__untar gcc-${GCC_VERSION} ${SRCDIR}/gcc-build
		__untar gmp-${GMP_VERSION} ${SRCDIR}/gcc-build/gmp
		__untar mpfr-${MPFR_VERSION} ${SRCDIR}/gcc-build/mpfr
		__untar mpc-${MPC_VERSION} ${SRCDIR}/gcc-build/mpc
		__patch gcc-${GCC_VERSION} gcc-build
		touch ${SRCDIR}/gcc-build/.prepared
	fi
	(cd ${SRCDIR} && ln -sf gcc-build ${product})
}

[ -d ${DLDIR} ] || mkdir -p ${DLDIR}
[ -d ${BUILDDIR} ] || mkdir -p ${BUILDDIR}
[ -d ${SRCDIR} ] || mkdir -p ${SRCDIR}
[ -d ${STAGINGDIR} ] || mkdir -p ${STAGINGDIR}
[ -L ${STAGINGDIR}/usr ] || ( cd ${STAGINGDIR} ; ln -s . usr )

export PATH=${STAGINGDIR}/bin:${PATH}

[ -f user-config.sh -o -L user-config.sh ] && {
	. user-config.sh
}