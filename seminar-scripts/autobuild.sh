#!/bin/sh
#
# Build defconfig $1
#
set -e # Fail on error
# Find where BuildRoot is
OLD_DIR="$(pwd)"
sh ./seminar-scripts/get-buildroot.sh
BR_DIR=$(find . -maxdepth 1 -name 'buildroot-*' -type d | head -n 1)
# Cleanup
cd "$BR_DIR"
if [ -d ./dl ]; then mv ./dl ..; fi
make distclean || true
if [ -d ../dl ]; then mv ../dl .; fi
make defconfig || true
cd "$OLD_DIR"
# Copy config
cp -f defconfigs/"$1" "$BR_DIR/configs/$1_defconfig"
# Copy scripts
find ./kconfigs -type f -name '*.kconfig' -exec cp -f {} "$BR_DIR" \;
find ./scripts -type f -name '*.sh' -exec cp -f {} "$BR_DIR" \;
find "$BR_DIR" -maxdepth 1 -name '*.sh' -exec chmod +x {} \;
# Download sources and build
cd "$BR_DIR"
make "$1_defconfig"
make source
if [ -n "$2" ]; then
  make "$2"
else
  make
fi
# Copy the results
cd "$OLD_DIR"
mkdir -p output/"$1"
find "$BR_DIR"/output/images -type f -exec cp -f {} output/"$1" \; 
