#!/bin/sh
#
# Automatically builds all BASC targets
#
set -e
sh ./scripts/autobuild-cross-compiler.sh
sh ./scripts/autobuild-rootfs.sh
sh ./scripts/autobuild-bootable-rootfs.sh
