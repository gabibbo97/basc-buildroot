#!/bin/sh
#
# Automatically downloads BuildRoot sources
#
BUILDROOT_VERSION='2020.08.1'
if [ -d "buildroot-${BUILDROOT_VERSION}" ]; then
  echo 'BuildRoot already downloaded'
  exit 0
fi

DL_URL="https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz"
if [ -x "$(command -v curl)" ]; then
  echo 'Downloading buildroot with curl'
  curl -L "${DL_URL}" | tar -xzf -
elif [ -x "$(command -v wget)" ]; then
  echo 'Downloading buildroot with wget'
  wget -O - "${DL_URL}" | tar -xzf -
else
  echo 'Install curl or wget' > /dev/stderr && exit 1
fi
#
# Apply patches
#
## Check
echo 'Checking patches'
git apply --check --directory="buildroot-${BUILDROOT_VERSION}" --exclude="buildroot-${BUILDROOT_VERSION}/DEVELOPERS" ./patches/uftrace.patch
## Apply
echo 'Applying patches'
git apply --directory="buildroot-${BUILDROOT_VERSION}" --exclude="buildroot-${BUILDROOT_VERSION}/DEVELOPERS" ./patches/uftrace.patch
cp ./patches/ltrace-assertion-failed.patch "buildroot-${BUILDROOT_VERSION}"/package/ltrace
