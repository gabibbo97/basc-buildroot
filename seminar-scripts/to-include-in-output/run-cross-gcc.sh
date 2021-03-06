#!/bin/sh
CROSS_COMPILER="arm-cross-compiler-5.4"
# Extract cross compiler
if ! [ -d ./"$CROSS_COMPILER"/arm-buildroot-linux-gnueabihf_sdk-buildroot ]; then
  echo 'Extracting cross-compiler'
  tar -C ./"$CROSS_COMPILER" -xf ./"$CROSS_COMPILER"/arm-buildroot-linux-gnueabihf_sdk-buildroot.tar.gz
  echo 'Extracted'
fi
# Find components
GCC=$(find ./"$CROSS_COMPILER" -type f,l -executable -name '*-gcc' | head -n 1)
# Run
exec "$GCC" "$@"
