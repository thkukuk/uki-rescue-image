#! /bin/bash

set -e

# Create new os-release
. /buildroot/usr/lib/os-release

GLIBC_VERSION=$(rpm -q --qf '%{NAME}-%{VERSION}' glibc)

cat <<EOF > /buildroot/usr/lib/os-release
NAME="UKI Rescue Image"
ID="uki-rescue-image"
VERSION_ID="${VERSION_ID}"
PRETTY_NAME="UKI Rescue Image (${VERSION_ID}-${IMAGE_VERSION})"
SYSEXT_LEVEL="${GLIBC_VERSION}"
EOF
