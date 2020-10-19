#!/bin/sh
#
# Automatically builds all BASC targets
#
set -e
# Invoke sub build scripts
sh ./scripts/autobuild-cross-compiler.sh
sh ./scripts/autobuild-rootfs.sh
sh ./scripts/autobuild-bootable-rootfs.sh
# Package if asked
if [ "$1" = "package" ]; then
  (
    cd ./output
    for dir in ./*; do
      # Skip non-directories
      [ -d "$dir" ] || continue
      # Package using tar
      tar -cf $(basename "$dir").tar "$dir"
      xz -T0 -9 -e $(basename "$dir").tar
      sha512sum $(basename "$dir").tar.xz $(basename "$dir").tar.xz.sha512sum
    done
  )
fi
