#!/bin/sh
#
# Automatically packages everything
#
tar \
  --create \
  --sparse \
  --verbose \
  --directory=output \
  --zstd \
  --file output/buildroot.tar.zst ./bootable-rootfs ./cross-compiler ./rootfs ./boot-rootfs.sh ./run-cross-gdb.sh
(cd output && sha512sum buildroot.tar.zst > buildroot.tar.zst.sha512sums)
