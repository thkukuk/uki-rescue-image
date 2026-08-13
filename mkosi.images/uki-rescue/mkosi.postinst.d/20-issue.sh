#! /bin/bash

set -e

# Get VERSION_ID
. /buildroot/usr/lib/os-release

# Create new issue
cat <<EOF > /buildroot/usr/lib/issue.d/10-openSUSE.issue
UKI Rescue Image ${VERSION_ID}-${IMAGE_VERSION} - Kernel \r (\l).

EOF
