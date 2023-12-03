#!/bin/bash

# Define package details
PACKAGE_NAME="USBCamStreamer"
VERSION="0.1"
MAINTAINER="justaCasualCoder"
DESCRIPTION='Script for streaming video from USB cam to browser'

# Create a temporary directory for packaging
TMP_DIR=$(mktemp -d /tmp/${PACKAGE_NAME}_packaging.XXXXXX)
BIN_DIR="${TMP_DIR}/usr/bin"
MAN_DIR="${TMP_DIR}/usr/share/man/man1/"
DEBIAN_DIR="${TMP_DIR}/DEBIAN"

# Create necessary directories
mkdir -p "${BIN_DIR}"
mkdir -p "${MAN_DIR}"
mkdir -p "${DEBIAN_DIR}"

# Copy files to the temporary directory
install -m 755 USBCamStreamer.sh "${BIN_DIR}/USBCamStreamer"
install -m 644 USBCamStreamer.manpage "${MAN_DIR}/USBCamStreamer.1"

# Create the control file
CONTROL_FILE="${DEBIAN_DIR}/control"
echo "Package: ${PACKAGE_NAME}" > "${CONTROL_FILE}"
echo "Version: ${VERSION}" >> "${CONTROL_FILE}"
echo "Section: custom" >> "${CONTROL_FILE}"
echo "Priority: optional" >> "${CONTROL_FILE}"
echo "Architecture: all" >> "${CONTROL_FILE}"
echo "Maintainer: ${MAINTAINER}" >> "${CONTROL_FILE}"
echo "Description: ${DESCRIPTION}" >> "${CONTROL_FILE}"

# Set permissions
chmod -R 755 "${DEBIAN_DIR}"

# Build the Debian package
dpkg-deb --build "${TMP_DIR}" "${PACKAGE_NAME}_${VERSION}_all.deb"

# Clean up temporary files
rm -r "${TMP_DIR}"

echo "Package created: ${PACKAGE_NAME}_${VERSION}_all.deb"
