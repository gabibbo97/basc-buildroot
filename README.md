# Buildroot notes for BASC seminar

## About buildroot

Buildroot is a set of [Makefile](https://en.wikipedia.org/wiki/Make_(software)) + [KConfig](https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html) scripts that tries to create an easy way for creating root images.

The main consumers of buildroot are enterprises creating Linux based embedded systems, think of:

- IoT
- Automated factory control
- Point of sale devices
- Car media units

The basic flow that buildroot supports is:

- Creating a configuration file
- Starting the build
- Directly flashing the built image on devices

Beyond the curtain what buildroot does for us is:

- Building a cross compiler (so we can use our powerful build machine)
- Resolving dependencies
- Compiling from source for our target platform the packages
- Assembling an image

Why buildroot:

- Each buildroot is a 100% custom Linux "mini-distro"
- Buildroot images can be less than 100MB or even 10MB
- Complete customization of target architecture and build flags
- Multiple compiler / libc / system layout choices
- Updated every 3 months
- Easily extendable

~20 architectures are supported:

- ARC (LE & BE)
- ARM (LE & BE)
- AArch64 (LE & BE)
- csky
- i386
- m68k
- Microblaze AXI
- Microblaze non-AXI
- MIPS (LE & BE)
- MIPS64 (LE & BE)
- nds32
- Nios II
- PowerPC
- PowerPC64 (LE & BE)
- RISCV
- SuperH
- SPARC
- x86_64
- Xtensa

## Obtaining

```sh
curl -L https://buildroot.org/downloads/buildroot-2020.08.tar.gz | tar -xzf -
```

## Commands

- `make list-defconfigs` show available config templates
- `make <defconfig>` set the current config to a template
- `make savedefconfig` save the current configuration in cleaned up form to a file named `defconfig`
- `make menuconfig` open configuration
- `make` build the project
- `make distclean` cleanup buildroot build directory
- `make help` show available options

## Creating our own ARM cross-compiler

- Cleanup the environment with `make distclean`
- Run `make menuconfig`
- Target options ->
  - Target Architecture = ARM (little endian)
  - Target Architecture Variant = cortex-A9
  - [x] Enable VFP extension support
- Toolchain ->
  - C library = glibc
  - [x] Enable C++ support
  - [x] Build cross gdb for the host
  - [x] TUI support
- Save
- Run `make toolchain` and go grab a coffee
- Version `2020.08` will build you a `GCC 9.3` custom toolchain
- You will find gcc at `output/host/bin/arm-buildroot-linux-gnueabihf-gcc`

To setup the current shell to use the newly built cross compiler:

```sh
export PATH="${PATH}:${PWD}/output/host/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PWD}/output/host/lib"
```

Try to build `hello-arm` with `arm-buildroot-linux-gnueabihf-gcc ../hello_arm.c -o hello-arm`

```sh
> file ../hello-arm
../hello-arm: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 5.7.0, not stripped
```

## Creating our own ARM buildroot

- Cleanup the environment with `make distclean`
- Run `make menuconfig`
- Target options ->
  - Target Architecture = ARM (little endian)
  - Target Architecture Variant = cortex-A9
  - [x] Enable VFP extension support
- Toolchain ->
  - C library = glibc
  - [x] Enable C++ support
  - [x] Build cross gdb for the host
  - [x] TUI support
- Build options ->
  - [x] build packages with debugging symbols
  - gcc debug level = debug level 3
  - [ ] strip taget binaries
  - gcc optimization level = optimization level 0
- Target packages ->
  - Debugging, profiling and benchmark ->
    - [x] gdb
    - [x] full debugger
    - [x] gdbserver
    - [x] TUI support
- Filesystem images ->
  - [x] tar the root filesystem
- Save
- Run `make source` to download sources
- Run `make` and go grab a coffee
- You will our rootfs in `output/images/rootfs.tar`



### Usage of the rootfs

![Buildroot inviting us to install QEMU static](README_data/ChrootCaveats.png)

#### Docker

```sh
sudo docker import output/images/rootfs.tar basc-buildroot
sudo docker run --rm -it \
  --volume "$(which qemu-arm-static):/bin/qemu-arm-static" \
  --volume "../:/host" \
  --entrypoint /bin/qemu-arm-static \
  --workdir "/host" \
  basc-buildroot \
  /bin/sh
```

#### Systemd-nspawn (like chroot)

```sh
mkdir -p basc-rootfs
tar -xf output/images/rootfs.tar -C basc-rootfs
# If you have binfmt_misc support enabled
sudo systemd-nspawn --register=no -D basc-rootfs /bin/sh
# If you don't have binfmt_misc support enabled
cp -f "$(which qemu-arm-static)" basc-rootfs/bin/qemu-arm-static
sudo systemd-nspawn --register=no -D basc-rootfs /bin/qemu-arm-static /bin/sh
```

## Creating a bootable ARM image

<!-- - Cleanup the environment with `make distclean`
- Run `make menuconfig`
- Target options ->
  - Target Architecture = ARM (little endian)
  - Target Architecture Variant = cortex-A9
  - [x] Enable VFP extension support
- Toolchain ->
  - C library = glibc
  - [x] Enable C++ support
  - [x] Build cross gdb for the host
  - [x] TUI support
- System configuration ->
  - Root password = BASC2020
- Kernel ->
  - [x] Linux Kernel ->
    - Kernel configuration = Use the architecture default configuration
- Target packages ->
  - Crypto ->
    - openssl support
- Filesystem images ->
  - [x] btrfs root filesystem
  - [ ] tar the root filesystem
- Bootloaders ->
  - [x] grub2
- Save
- Run `make source` to download sources
- Run `make` and go grab a coffee -->

## Customizing our images

### At build time

- Create a directory `my-overlay`
- Add inside `.config`

```sh
BR2_ROOTFS_OVERLAY=my-overlay
```

- Insert the files inside `my-overlay`
- Rebuild using `make`
- The rootfs will contain also the overlay

### After build

#### Rebuilding using buildroot

- Add your files inside `output/target`
- Rebuild using `make`

__Your files might be rewritten / deleted__

#### Do it yourself

- Unpack your rootfs (with `tar -xzf` for instance)
- Add the files
- Repack your rootfs (with `tar -cf` for instance)

## Why there's no compiler / libraries inside buildroot?

Citing the manual:

- Buildroot mostly targets small or very small target hardware with limited resource onboard (CPU, ram, mass-storage), for which compiling on the target does not make much sense
- Buildroot aims at easing the cross-compilation, making native compilation on the target unnecessary
- Since there is no compiler available on the target, it does not make sense to waste space with headers or static libraries

## More info

See the [official manual](https://buildroot.org/downloads/manual/manual.html#_chroot)
