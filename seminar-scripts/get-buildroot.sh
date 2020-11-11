#!/bin/sh
if ! [ -x "$(command -v git)" ]; then
  echo 'Install git' > /dev/stderr && exit 1
fi
if ! [ -x "$(command -v find)" ]; then
  echo 'Install find' > /dev/stderr && exit 1
fi
#
# Automatically downloads BuildRoot sources
#
BUILDROOT_VERSION='2020.11-rc1'
if [ -d "buildroot-${BUILDROOT_VERSION}" ]; then
  echo 'BuildRoot already downloaded'
  exit 0
fi
git clone --depth=1 -b "${BUILDROOT_VERSION}" https://git.busybox.net/buildroot "buildroot-${BUILDROOT_VERSION}"
#
# Apply patches
#
echo 'Copying patches'

find "./buildroot-${BUILDROOT_VERSION}/package/gdb" -mindepth 1 -maxdepth 1 -type d | while read -r gdbVerDir; do
  MAXN=$(find "$gdbVerDir" -type f -name '*.patch' | sort | tail -n1 | xargs basename | cut -d- -f1)
  DEST_FILENAME=$(printf '%04d' "$(( MAXN + 1 ))")-gdb-python39.patch
  cp ./patches/gdb-python39.patch "${gdbVerDir}/${DEST_FILENAME}"
done

echo 'Applying patches'
(cd "buildroot-${BUILDROOT_VERSION}" && git am ../patches/*uftrace*.patch)
