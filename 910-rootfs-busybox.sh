#!/bin/sh

. config.sh

__untar busybox-${BUSYBOX_VERSION} ${BUILDDIR}/busybox-${BUSYBOX_VERSION}

make -C ${BUILDDIR}/busybox-${BUSYBOX_VERSION} \
	V=1 \
	CROSS_COMPILE=${TARGET}- \
	ARCH=${TARGET} \
	CONFIG_ROOT=${ROOTDIR} \
	defconfig

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
