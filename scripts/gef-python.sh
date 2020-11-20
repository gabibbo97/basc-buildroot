#!/bin/sh
set -e # Fail on error
#
# Install GEF's python dependencies
#
PYTHON_BINARY="${HOST_DIR}/bin/python3"
PIP_BINARY="${HOST_DIR}/bin/pip3"
# Check python
if ! [ -x "${PYTHON_BINARY}" ]; then
  echo 'Python3 not found' > /dev/stderr
  exit 1
fi
# Install pip
if ! [ -x "${PIP_BINARY}" ]; then
  downloadGetPIP() {
    if [ -x "$(command -v curl)" ]; then
      curl -L https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    elif [ -x "$(command -v wget)" ]; then
      wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
    else
      echo 'Install curl or wget' > /dev/stderr && exit 1
    fi
  }
  downloadGetPIP
  eval "${PYTHON_BINARY}" /tmp/get-pip.py --isolated
fi
# Install GEF prerequisites
eval "${PIP_BINARY}" install --isolated \
  capstone \
  keystone-engine \
  unicorn \
  ropper \
  pwntools
# Delete Python compiler cache
find "$BASE_DIR" -name '*.pyc' -delete
