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

__prepare_source busybox-${BUSYBOX_VERSION}

make -C ${BUILDDIR}/busybox-${BUSYBOX_VERSION} \
	V=1 \
	CROSS_COMPILE=${TARGET}- \
	ARCH=${TARGET} \
	CONFIG_ROOT=${ROOTDIR} \
	allyesconfig

# musl need some extra work to have everything ok
# see http://wiki.musl-libc.org/wiki/Building_Busybox
if [ "${LIBC_NAME}" = "musl" ]; then
	remove=""
	remove="${remove} EXTRA_COMPAT SELINUX FEATURE_HAVE_RPC WERROR"
	remove="${remove} FEATURE_SYSTEMD FEATURE_VI_REGEX_SEARCH PAM"
	remove="${remove} FEATURE_INETD_RPC SELINUXENABLED"
	remove="${remove} FEATURE_MOUNT_NFS"
	cp ${BUILDDIR}/busybox-${BUSYBOX_VERSION}/.config ${BUILDDIR}/busybox-${BUSYBOX_VERSION}/.unsed-config
	for v in ${remove} ; do
		sed -i 's:^\(CONFIG_'$v'\).*$:# \1 is not set:' ${BUILDDIR}/busybox-${BUSYBOX_VERSION}/.config
	done

	make -C ${BUILDDIR}/busybox-${BUSYBOX_VERSION} \
		V=1 \
		CROSS_COMPILE=${TARGET}- \
		ARCH=${TARGET} \
		CONFIG_ROOT=${ROOTDIR} \
		oldconfig
fi

__patch_after_prepare busybox-${BUSYBOX_VERSION}

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
