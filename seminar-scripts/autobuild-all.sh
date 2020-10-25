#!/bin/sh
#
# Automatically builds all BASC targets
#
set -e
# Invoke sub build scripts
sh ./seminar-scripts/autobuild-cross-compiler.sh
sh ./seminar-scripts/autobuild-rootfs.sh
sh ./seminar-scripts/autobuild-bootable-rootfs.sh
# Add scripts
for script in ./seminar-scripts/to-include-in-output/*; do
  cp -f "$script" ./output
done
