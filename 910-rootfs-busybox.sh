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

__untar busybox-${BUSYBOX_VERSION} ${BUILDDIR}/busybox-${BUSYBOX_VERSION}

make -C ${BUILDDIR}/busybox-${BUSYBOX_VERSION} \
	V=1 \
	CROSS_COMPILE=${TARGET}- \
	ARCH=${TARGET} \
	CONFIG_ROOT=${ROOTDIR} \
	defconfig

make -C ${BUILDDIR}/busybox-${BUSYBOX_VERSION} \
	V=1 \
	CROSS_COMPILE=${TARGET}- \
	CONFIG_ROOT=${ROOTDIR} \
	ARCH=${TARGET}

make -C ${BUILDDIR}/busybox-${BUSYBOX_VERSION} \
	V=1 \
	CROSS_COMPILE=${TARGET}- \
	ARCH=${TARGET} \
	CONFIG_ROOT=${ROOTDIR} \
	install
