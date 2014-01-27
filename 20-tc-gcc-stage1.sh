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

__prepare_gcc gcc-stage1

__configure gcc-stage1 \
	--prefix=${STAGINGDIR} \
	--target=${TARGET} \
	--enable-languages=c \
	--with-sysroot=${SYSROOT} \
	--with-gnu-ld \
	--disable-multilib \
	--disable-libssp \
	--disable-libquadmath \
	--disable-threads \
	--disable-decimal-float \
	--disable-shared \
	--disable-libmudflap \
	--disable-libgomp \
	--disable-libatomic \
	--with-newlib \
	--without-headers \
	$(GCC_S1_CONFIGURE_ARGS)

export SHELL=/bin/bash
make -C ${BUILDDIR}/gcc-stage1 all-gcc all-target-libgcc install-gcc install-target-libgcc
