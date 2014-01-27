#!/bin/sh

. config.sh

__untar linux-${LINUX_VERSION} ${BUILDDIR}/linux-${LINUX_VERSION}

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
		CROSS_COMPILE=${TARGET}-
)
