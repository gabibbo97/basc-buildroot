#!/bin/sh
exec ssh \
  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -p 2222 \
  root@localhost
