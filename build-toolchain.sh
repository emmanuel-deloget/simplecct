#!/bin/sh

. config.sh

usage() {
cat << EOF
${0}: build a cross compilation toolchain
usage: ${0} [option]...
options are:
	help: this screen
	nodl: do not download the needed files
	nobinutils: do not build binutils
	nostage1: do not build the stage 1 of gcc
	nostage2: do not build the stage 2 of gcc
	nolibc: do not build the standard C library
	nokheaders: do not extract the kernel headers
	nolinux: do not build the linux kernel
	clean: remove all generated files
	config=CONFIG: use some premade additional configuration.
	end: stop doing anything after this option

The following additions configuration are available:
	$(cd configs && ls -1 *.sh | sed 's:\.sh::g')
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
	nostage2)
		nsl="${nsl} 50-tc-gcc-stage2.sh"
		;;
	nolibc)
		nsl="${nsl} 40-tc-libc.sh"
		;;
	nokheaders)
		nsl="${nsl} 30-tc-kheaders.sh"
		;;
	nolinux)
		nsl="${nsl} 80-tc-linux.sh"
		;;
	clean)
		rm -rf ${STAGINGDIR} ${BUILDDIR} ${SRCDIR}/gcc-build ${SRCDIR}/gcc-stage*
		[ -L user-config.sh ] && rm -f user-config.sh
		;;
	config=*)
		cf=${opt##config=}
		[ -f ${CONFDIR}/${cf}.sh ] && {
			ln -s ${CONFDIR}/${cf}.sh user-config.sh
			. config.sh
		} || {
			error "configuration <${cf}> does not exist"
		}
		;;
	end)
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
