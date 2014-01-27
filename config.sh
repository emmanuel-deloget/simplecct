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

# default values
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

TARGET=
LINUX_ARCH=
LINUX_DEF_CONFIG=

GCC_S1_CONFIGURE_ARGS=
GCC_S2_CONFIGURE_ARGS=

# user values
[ -f user-config.sh -o -L user-config.sh ] && {
	. user-config.sh
}

LANG=C
TOPDIR=$(pwd)

DLDIR=${TOPDIR}/.download
SRCDIR=${TOPDIR}/.source
PATCHDIR=${TOPDIR}/patches
CONFDIR=${TOPDIR}/configs

if [ -n "${TARGET}" ]; then
	BUILDDIR=${TOPDIR}/.build/${TARGET}
	STAGINGDIR=${TOPDIR}/staging/${TARGET}/host
	ROOTDIR=${TOPDIR}/staging/${TARGET}/target
	SYSROOT=${STAGINGDIR}
fi

error() {
	echo $1 1>&2
	exit 1
}

__check_target() {
	[ -n "${TARGET}" ] || {
		error "TARGET is empty, I cannot build a cross-compiler"
	}
}

__configure() {
	local product=${1}
	shift

	__check_target

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

	if [ ! -f ${dest}/.untarred ]; then
		mkdir -p ${dest}
		tar xf ${file} --strip-components=1 -C ${dest} || {
			error "cannot extract <${file}> to <${dest}>"
		}
		touch ${dest}/.untarred
	fi
}

__download_and_untar() {
	local product=${1}
	local url=${2}
	local file=$(basename ${url})

	if [ ! -f ${DLDIR}/${file} ]; then
		wget ${url} -O ${DLDIR}/${file} || error "cannot download <${url}>"
	fi
	__untar ${product} ${SRCDIR}/${product}
}

__patch() {
	local base=${1}
	local dest=${2}

	__check_target

	if ! which quilt > /dev/null 2>&1; then
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

	__check_target

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
[ -d ${SRCDIR} ] || mkdir -p ${SRCDIR}

if [ -n "${TARGET}" ]; then
	[ -d ${BUILDDIR} ] || mkdir -p ${BUILDDIR}
	[ -d ${STAGINGDIR} ] || mkdir -p ${STAGINGDIR}
	[ -L ${STAGINGDIR}/usr ] || ( cd ${STAGINGDIR} ; ln -s . usr )
fi

export PATH=${STAGINGDIR}/bin:${PATH}
