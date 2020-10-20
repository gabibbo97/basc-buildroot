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
      xz \
        -T0 \
        --arm \
        --lzma2=dict=$(( 1024 * 1024 * 384 )),lc=4,pb=4,mf=bt4,mode=normal,nice=273,depth=4096 \
        $(basename "$dir").tar
    done
    sha512sum ./*.tar.xz checksums.sha512sum
  )
fi
