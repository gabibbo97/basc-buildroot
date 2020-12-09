#!/bin/sh
#
# Automatically builds all BASC targets
#
set -e
# Build
sh ./seminar-scripts/autobuild.sh 'arm-cross-compiler' 'sdk'
sh ./seminar-scripts/autobuild.sh 'arm-cross-compiler-5.4' 'sdk'
sh ./seminar-scripts/autobuild.sh 'arm-rootfs'
sh ./seminar-scripts/autobuild.sh 'arm-rootfs-5.4'
sh ./seminar-scripts/autobuild.sh 'arm-bootable-rootfs'
# Package
sh ./seminar-scripts/autobuild-package.sh
