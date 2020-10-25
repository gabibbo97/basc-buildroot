# seminar-scripts

These scripts are used to build the deliverables utilised in the seminar.

- [autobuild-all.sh](./autobuild-all.sh) automatically all of the required packages
- [autobuild-bootable-rootfs.sh](./autobuild-bootable-rootfs.sh) automatically build an ARM LE bootable rootfs
- [autobuild-cross-compiler.sh](./autobuild-cross-compiler.sh) automatically build an ARM LE cross compiler
- [autobuild-rootfs.sh](./autobuild-rootfs.sh) automatically build an ARM LE rootfs
- [autobuild-package.sh](./autobuild-package.sh) compresses all files into a single archive
- [get-buildroot.sh](./get-buildroot.sh) downloads Buildroot into the current directory

## Scripts to include in output

- [boot-rootfs.sh](./to-include-in-output/boot-rootfs.sh) boots the bootable rootfs using QEMU
- [run-cross-gdb.sh](./to-include-in-output/run-cross-gdb.sh) starts a preconfigured gdb with the cross-compiler
