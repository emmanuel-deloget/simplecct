#!/bin/sh

. config.sh

for p in make gcc quilt; do
	if ! which ${p}; then
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
		nsl="${nsl} 00-tc-binutils.sh"
		;;
	nostage1)
		nsl="${nsl} 00-tc-gcc-stage1.sh"
		;;
	nostage2)
		nsl="${nsl} 00-tc-gcc-stage2.sh"
		;;
	nolibc)
		nsl="${nsl} 00-tc-libc.sh"
		;;
	nokheaders)
		nsl="${nsl} 00-tc-kheaders.sh"
		;;
	clean)
		rm -rf ${STAGINGDIR} ${BUILDDIR} ${SRCDIR}/gcc-build ${SRCDIR}/gcc-stage*
		;;
	esac
done

for script in [0-9][0-9]-tc-*.sh; do
	if ! echo ${nsl} | grep -q ${script}; then
		. ${script}
	fi
done
