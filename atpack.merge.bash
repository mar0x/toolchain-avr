#!/bin/bash -ex

#copy relevant files to the right folders
# 1 - copy includes definitions
cp -rpn include/avr ../objdir/avr/include/ ||:

# 2 - compact specs into a single folder
mkdir temp
cp -rp gcc/dev/*/* temp/

# 3 - copy device-specs
cp -rpn temp/device-specs ../objdir/lib/gcc/avr/${GCC_VERSION}/ ||:

#since https://github.com/gcc-mirror/gcc/commit/21a6b87b86defda10ac903a9cd49e34b1f8ce6fb a lot of devices has specs but avr-libc doesn't support them yet
ALL_DEVICE_SPECS=`ls temp/device-specs`
rm -rf temp/device-specs

cp -rpn temp/* ../objdir/avr/lib/ ||:

# 4 - extract the correct includes and add them to io.h
# ARGH! difficult!
for x in $ALL_DEVICE_SPECS; do
  DEFINITION=`cat ../objdir/lib/gcc/avr/${GCC_VERSION}/device-specs/${x} | grep __AVR_DEVICE_NAME__ | cut -f1 -d" " | sed 's/^[[:space:]]*-D//'`
  if ! grep -q "${DEFINITION}" ../objdir/avr/include/avr/io.h ; then
    # FANCY_NAME=`cat ../objdir/lib/gcc/avr/${GCC_VERSION}/device-specs/${x} | grep __AVR_DEVICE_NAME__ | cut -f2 -d"="`
    HEADER=`echo "${DEFINITION}" | tr '[:upper:]' '[:lower:]'`
    HEADER=${HEADER%__}
    case ${HEADER} in
        __avr_attiny*) HEADER=${HEADER#__avr_attiny}; PREFIX=tn ;;
        __avr_atmega*) HEADER=${HEADER#__avr_atmega}; PREFIX=m ;;
        __avr_*) HEADER=${HEADER#__avr_}; PREFIX="" ;;
    esac

    cat <<EOF >script.sed
/iom3000.h/a\\
#elif defined (${DEFINITION})\\
#  include <avr/io${PREFIX}${HEADER}.h>
EOF

    sed -f script.sed  -i '' ../objdir/avr/include/avr/io.h
  fi
done
