#!/bin/sh

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
make ${MAKEJOBS} -C ${BUILDDIR}/gcc-stage1 all-gcc all-target-libgcc install-gcc install-target-libgcc
