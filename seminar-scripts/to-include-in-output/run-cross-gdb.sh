#!/bin/sh
# Extract cross compiler
if ! [ -d ./cross-compiler/arm-buildroot-linux-gnueabihf_sdk-buildroot ]; then
  echo 'Extracting cross-compiler'
  tar -C ./cross-compiler -xf ./cross-compiler/arm-buildroot-linux-gnueabihf_sdk-buildroot.tar.gz
  echo 'Extracted'
fi
# Find components
GDB=$(find . -type f -executable -name '*-gdb' | head -n 1)
GDBINIT=$(find . -type f -name 'gdbinit' | head -n 1)
# Run GDB
exec "$GDB" -x "$GDBINIT" "$@"
