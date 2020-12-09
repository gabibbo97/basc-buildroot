#!/bin/sh
#
# Build the release package
#
# Copy scripts
find ./seminar-scripts/to-include-in-output -type f -exec cp -f {} ./output \;
find ./output -type f -name '*.sh' -exec chmod +x {} \;
# Tar everything
tar -cJvf buildroot.tar.xz -C output .
sha512sum buildroot.tar.xz > buildroot.tar.xz.sha512sums
