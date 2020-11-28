#!/bin/sh
set -e # Fail on error
# Checks
fail() {
    echo "$1" > /dev/stderr
    exit 1
}
[ -x "$(command -v qemu-arm-static)" ] || fail "Please install qemu-arm-static"
[ -x "$(command -v systemd-nspawn)" ] || fail "Please install system-nspawn"
[ -x "$(command -v tar)" ] || fail "Please install tar"
# Extract rootfs
if ! [ -d rootfs/rootfs ]; then
    echo 'Extracting rootfs'
    mkdir rootfs/rootfs
    tar -C rootfs/rootfs -xf rootfs/rootfs.tar
fi
# Copy qemu-arm-static
cp -f "$(which qemu-arm-static)" rootfs/rootfs/bin/qemu-arm-static
# Startup
sudo systemd-nspawn --register=no -D ./rootfs/rootfs /bin/qemu-arm-static /bin/sh
