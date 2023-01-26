#!/bin/bash
#
# Generates a release.py file based on a template. For use within a Github Action workflow, or locally.
#
# Usage:
#
# ```bash
#  bash write_release.sh OUTPUT_PATH="./" RELEASE_VERSION="v1.1.1" GITHUB_SHA="4ae4699e16b2163ef7ba7c89263443cea571d98f"
#
# Defaults:
#   OUTPUT_PATH = "./mbm/"
#   RELEASE_VERSION = "$(git tag --sort=-creatordate  | head -1)"
#   GITHUB_SHA = "$(git rev-parse HEAD)"
# ```

set -eu

# The following parses input arguments in key-value pairs
for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

script_name=`basename $0`
echo "[INFO] Entering $script_name..."

RELEASE_VERSION=${RELEASE_VERSION:-"$(git tag --sort=-creatordate  | head -1)"}
GITHUB_SHA=${GITHUB_SHA:-"$(git rev-parse HEAD)"}
OUTPUT_PATH=${OUTPUT_PATH:-"./mbm/"}

cat > $OUTPUT_PATH/release.py <<-EOF
release_metadata = {
  "release_version": "$RELEASE_VERSION",
  "commit_hash": "$GITHUB_SHA"
}
EOF

cat  $OUTPUT_PATH/release.py

echo "[INFO] Exiting $script_name..."

