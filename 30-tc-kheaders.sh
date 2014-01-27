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

. config.sh

if [ -n "${SABOTAGE_KH_VERSION}" ]; then
	# if we want to use sabotage, just do it!
	__untar kernel-headers-${SABOTAGE_KH_VERSION} ${BUILDDIR}/kernel-headers

	# sh4rm4: the latest sabotage tarball is broken
	# it's missing a few commits (applied as patches)
	__patch_after_prepare \
		kernel-headers-${SABOTAGE_KH_VERSION} \
		kernel-headers

	make -C ${BUILDDIR}/kernel-headers 	\
		ARCH=${LINUX_ARCH}		\
		DESTDIR=${SYSROOT}		\
		prefix=/usr			\
		install

else
	# standard behavior
	__untar linux-${LINUX_VERSION} ${BUILDDIR}/kernel-headers

	make -C ${BUILDDIR}/kernel-headers \
		V=1 \
		ARCH=${LINUX_ARCH} \
		CROSS_COMPILE=${TARGET}- \
		${LINUX_DEF_CONFIG}

	make -C ${BUILDDIR}/kernel-headers \
		V=1 \
		ARCH=${LINUX_ARCH} \
		CROSS_COMPILE=${TARGET}- \
		INSTALL_HDR_PATH=${SYSROOT} \
		headers_install
fi
