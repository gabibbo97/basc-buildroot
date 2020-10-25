# scripts

These are meant to be used for BuildRoot after-build customization (option `BR2_ROOTFS_POST_BUILD_SCRIPT`)

- [enable-ssh-root-login.sh](./enable-ssh-root-login.sh) allows to login with SSH as root without having set up public key authentication
- [gef-python.sh](./gef-python.sh) installs the packages required by GEF into the buildroot provided Python
