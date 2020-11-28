#!/bin/sh
# Extract cross compiler
if ! [ -d ./cross-compiler/arm-buildroot-linux-gnueabihf_sdk-buildroot ]; then
  echo 'Extracting cross-compiler'
  tar -C ./cross-compiler -xf ./cross-compiler/arm-buildroot-linux-gnueabihf_sdk-buildroot.tar.gz
  echo 'Extracted'
fi
# Find components
GCC=$(find ./cross-compiler -type f,l -executable -name '*-gcc' | head -n 1)
# Run
exec "$GCC" "$@"
