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

usage() {
cat << EOF
${0}: build a cross compilation toolchain
usage: ${0} [option]...
options are:
	         help: displaythis screen.

	         nodl: do not download the needed files.
	   nobinutils: do not build binutils.
	     nostage1: do not build the stage 1 of gcc.
	     nostage2: do not build the stage 2 of gcc.
	       nolibc: do not build the standard C library.
	   nokheaders: do not extract the kernel headers.
	     norootfs: do not build the rootfs.

	config=CONFIG: setup some premade configuration and quit.
	               CONFIG is one of:
$(cd ${CONFDIR} && ls -1 *.sh | sed 's:\.sh::;s:^:\t\t\t    :')

	        clean: remove all generated files and quit.
EOF
}

for p in make gcc quilt; do
	if ! which ${p} > /dev/null 2>&1; then
		error "PREREQ: ${p} is not installed on your system"
	fi
done

nsl=""

for opt in "$@"; do
	case ${opt} in
	nodl)
		nsl="${nsl} 00-tc-download.sh"
		;;
	nobinutils)
		nsl="${nsl} 10-tc-binutils.sh"
		;;
	nostage1)
		nsl="${nsl} 20-tc-gcc-stage1.sh"
		;;
	nokheaders)
		nsl="${nsl} 30-tc-kheaders.sh"
		;;
	nolibc)
		nsl="${nsl} 40-tc-libc.sh"
		;;
	nostage2)
		nsl="${nsl} 50-tc-gcc-stage2.sh"
		;;
	norootfs)
		nsl="${nsl} 99-tc-image.sh"
		;;
	clean)
		rm -rf ${STAGINGDIR} ${BUILDDIR} ${SRCDIR}/gcc-build ${SRCDIR}/gcc-stage*
		[ -L user-config.sh ] && rm -f user-config.sh
		exit 0
		;;
	config=*)
		cf=${opt##config=}
		if [ -f ${CONFDIR}/${cf}.sh ]; then
			if [ ! -L user-config.sh ]; then
				error "user configuration cannot be changed, it's not a link"
			fi
			ln -sf ${CONFDIR}/${cf}.sh user-config.sh
			. config.sh
		else
			error "configuration <${cf}> does not exist"
		fi
		exit 0
		;;
	help)
		usage $(basename ${0})
		exit 1
		;;
	esac
done

for script in [0-9][0-9]-tc-*.sh; do
	if ! echo ${nsl} | grep -q ${script}; then
		. ${script}
	fi
done
