#!/bin/sh

. config.sh

__untar ${LIBC_NAME}-${LIBC_VERSION} ${BUILDDIR}/${LIBC_NAME}-${LIBC_VERSION}

(
	cd ${BUILDDIR}/${LIBC_NAME}-${LIBC_VERSION}
	CROSS_COMPILE=${TARGET}- configure \
		--target=${TARGET} \
		--disable-gcc-wrapper \
		--enable-debug \
		--prefix=${STAGINGDIR} \
		--target=${TARGET} \
		--with-sysroot=${SYSROOT}

	make -C ${BUILDDIR}/${LIBC_NAME}-${LIBC_VERSION} \
		all \
		install
)
