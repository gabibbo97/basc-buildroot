#!/bin/sh
#
# Automatically builds an ARM bootable rootfs
#
set -e # Fail on error
# Find where BuildRoot is
OLD_DIR="$(pwd)"
BR_DIR=$(find . -maxdepth 1 -name 'buildroot-*' -type d | head -n 1)
if [ -z "${BR_DIR}" ]; then
  sh ./seminar-scripts/get-buildroot.sh
fi
# Cleanup dir
echo 'Cleaning up BuildRoot directory'
cd "$BR_DIR"
if [ -d "$BR_DIR"/dl ]; then mv "$BR_DIR"/dl ..; fi
make distclean || true
if [ -d ../dl ]; then mv ../dl "$BR_DIR"; fi
make defconfig || true
cd "$OLD_DIR"
# Copy the files
mkdir -p "$BR_DIR"/configs
cp -f ./defconfigs/arm-bootable-rootfs "$BR_DIR"/configs/arm_bootable_rootfs_defconfig
cp -f ./kconfigs/virtio.kconfig "$BR_DIR"/virtio.kconfig
cp -f ./scripts/enable-ssh-root-login.sh "$BR_DIR" && chmod +x "$BR_DIR"/enable-ssh-root-login.sh
cp -f ./scripts/gef-python.sh "$BR_DIR" && chmod +x "$BR_DIR"/gef-python.sh
# Download sources and build
cd "$BR_DIR"
make arm_bootable_rootfs_defconfig
make source
make
# Copy here the results
cd "$OLD_DIR"
mkdir -p output/bootable-rootfs
for f in "$BR_DIR"/output/images/*; do
  cp -f "$f" ./output/bootable-rootfs
done
