#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "Generating NFS client provisioner resource definitions..."

helm template nfs-client-provisioner --namespace=nfs-client-provisioner "${SCRIPT_DIR}/_vendir/stable/nfs-client-provisioner/" \
        --values="${SCRIPT_DIR}/default-values.yml" |
  ytt --ignore-unknown-comments -f - |
  kbld -f - \
  > "${SCRIPT_DIR}/../../vendor/nfs-client-provisioner/rendered.yml"