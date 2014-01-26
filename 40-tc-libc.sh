#!/bin/sh

. config.sh

for lcs in 4[0-9]-${LIBC_NAME}-*.sh; do
	. ${lcs}
done
