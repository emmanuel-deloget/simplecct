#!/bin/sh

. config.sh

__configure binutils-${BINUTILS_VERSION} \
	--target=${TARGET} \
	--prefix=${STAGINGDIR} \
	--with-sysroot=${SYSROOT}

make -C ${BUILDDIR}/binutils-${BINUTILS_VERSION} all install
