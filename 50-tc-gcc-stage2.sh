#!/bin/sh

. config.sh

__prepare_gcc gcc-stage2

__configure gcc-stage2 \
	--prefix=${STAGINGDIR} \
	--target=${TARGET} \
	--enable-languages=c,c++ \
	--with-sysroot=${SYSROOT} \
	--disable-libmudflap \
	--disable-libsanitizer \
	$(GCC_S2_CONFIGURE_ARGS)

make -C ${BUILDDIR}/gcc-stage2 all install


