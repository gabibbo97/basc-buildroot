#!/bin/sh
#
# Automatically packages everything
#
rm -f output/buildroot.tar
tar \
  --create \
  --sparse \
  --verbose \
  --directory=output \
  --file output/buildroot.tar ./bootable-rootfs ./cross-compiler ./rootfs \
    ./boot-rootfs.sh \
    ./run-cross-gcc.sh \
    ./run-cross-gdb.sh \
    ./ssh.sh \
    ./sshfs.sh \
    ./systemd-nspawn.sh
rm -f output/buildroot.tar.xz
xz \
  --compress \
  --check=sha256 \
  --threads=0 \
  -9e \
  output/buildroot.tar
(cd output && sha512sum buildroot.tar.xz > buildroot.tar.xz.sha512sums)
