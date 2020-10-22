#!/bin/sh
#
# Automatically builds all BASC targets
#
set -e
# Invoke sub build scripts
sh ./scripts/autobuild-cross-compiler.sh
sh ./scripts/autobuild-rootfs.sh
sh ./scripts/autobuild-bootable-rootfs.sh
