#!/bin/sh
SSHD_CONFIG_FILE="${TARGET_DIR}/etc/ssh/sshd_config"
## Remove PermitRootLogin from config file
tmpfile=$(mktemp)
grep -v 'PermitRootLogin' "${SSHD_CONFIG_FILE}" > "$tmpfile"
mv "$tmpfile" "${SSHD_CONFIG_FILE}"
## Add our customizations
echo '# BASC BUILDROOT CUSTOMIZATION' >> "$SSHD_CONFIG_FILE"
echo 'PermitRootLogin yes' >> "$SSHD_CONFIG_FILE"
