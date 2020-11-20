SCRIPTS_DIR := ./seminar-scripts

.PHONY = all
all: presentation package
#
# Build targets
#
.PHONY = perms get-buildroot \
	cross-compiler \
	rootfs \
	bootable-rootfs \
	package

perms:
	find ./scripts -name '*.sh' -exec chmod +x {} \;
	find $(SCRIPTS_DIR) -name '*.sh' -exec chmod +x {} \;

get-buildroot: perms
	$(SCRIPTS_DIR)/$@.sh

output/cross-compiler: get-buildroot
	$(SCRIPTS_DIR)/autobuild-cross-compiler.sh

output/rootfs: output/cross-compiler get-buildroot
	$(SCRIPTS_DIR)/autobuild-rootfs.sh

output/bootable-rootfs: output/rootfs get-buildroot
	$(SCRIPTS_DIR)/autobuild-bootable-rootfs.sh

package: output/bootable-rootfs output/rootfs output/cross-compiler
	cp $(SCRIPTS_DIR)/to-include-in-output/* output
	$(SCRIPTS_DIR)/autobuild-package.sh
#
# Presentation subtarget
#
.PHONY = presentation
presentation:
	$(MAKE) -C presentation

#
# Cleanup
#
.PHONY = clean
clean:
	rm -rf \
		./buildroot-* \
		./output/*
