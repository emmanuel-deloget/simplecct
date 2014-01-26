#!/bin/sh

. config.sh

__untar linux-${LINUX_VERSION} ${BUILDDIR}/kernel-headers

make -C ${BUILDDIR}/kernel-headers \
	V=1 \
	ARCH=${LINUX_ARCH} \
	CROSS=${TARGET}- \
	${LINUX_DEF_CONFIG}

make -C ${BUILDDIR}/kernel-headers \
	V=1 \
	ARCH=${LINUX_ARCH} \
	CROSS=${TARGET}- \
	INSTALL_HDR_PATH=${STAGINGDIR} \
	headers_install