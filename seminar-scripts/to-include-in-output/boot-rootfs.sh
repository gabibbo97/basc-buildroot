#!/bin/sh
#
# Boots the built rootfs
#
exec qemu-system-arm \
  -machine virt \
  -cpu cortex-a7 \
  -smp 2 -m 2000 \
  -kernel bootable-rootfs/zImage \
  -device virtio-blk-device,drive=rootfs \
  -drive file=bootable-rootfs/rootfs.ext2,if=none,format=raw,id=rootfs \
  -append "console=ttyAMA0,115200 rootwait root=/dev/vda" \
  -netdev user,id=user0,hostfwd=tcp::2222-:22,hostfwd=tcp::1234-:1234 \
  -device virtio-net-device,netdev=user0 \
  -serial stdio \
  -display none
