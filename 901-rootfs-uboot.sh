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

uboot_build() {
	__prepare_source u-boot-${UBOOT_VERSION}

	(
		cd ${BUILDDIR}/u-boot-${UBOOT_VERSION}
		CROSS_COMPILE=${TARGET}- \
			MAKEALL -c ${UBOOT_CPU} -a ${UBOOT_ARCH}
	)
}

# we don't build uboot if we do not target any ARM platform
case ${TARGET} in
arm*)
	uboot_build
	;;
*)
	echo "*** uboot is not build for non-ARM targets"
	echo "*** current target is <${TARGET}>"
esac

