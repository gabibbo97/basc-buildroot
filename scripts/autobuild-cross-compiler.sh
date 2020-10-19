#!/bin/sh
#
# Automatically builds an ARM cross-compiler
#
set -e # Fail on error
# Find where BuildRoot is
OLD_DIR="$(pwd)"
BR_DIR=$(find . -maxdepth 1 -name 'buildroot-*' -type d | head -n 1)
if [ -z "${BR_DIR}" ]; then
  sh ./scripts/get-buildroot.sh
fi
# Cleanup dir
echo 'Cleaning up BuildRoot directory'
cd "$BR_DIR"
make clean || true
make defconfig
cd "$OLD_DIR"
# Copy the files
cp -f ./defconfigs/arm-cross-compiler "$BR_DIR"/.config
cp -f ./scripts/gef-python.sh "$BR_DIR"
# Download sources and build
cd "$BR_DIR"
make olddefconfig
make source
make sdk
# Copy here the results
cd "$OLD_DIR"
mkdir -p output/cross-compiler
for f in "$BR_DIR"/output/images/*; do
  cp -f "$f" ./output/cross-compiler
done
