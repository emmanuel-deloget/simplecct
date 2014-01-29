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

__prepare_source linux-${LINUX_VERSION}

(
	cd ${BUILDDIR}/linux-${LINUX_VERSION}
	make \
		V=1 				\
		ARCH=${LINUX_ARCH} 		\
		CROSS_COMPILE=${TARGET}- 	\
		${LINUX_DEF_CONFIG}

	make \
		V=1				\
		ARCH=${LINUX_ARCH} 		\
		CROSS_COMPILE=${TARGET}-	\
		all zImage
	[ $? -eq 0 ] || {
		error "kernel: failed to build the kernel zImage"
	}

	# we need to do something to install the beast in ${ROOTDIR}
	# but we cannot use any install rule from the kernel
	# Makefile as it will use /sbin/installkernel whatever we
	# do (weird but true)
)
