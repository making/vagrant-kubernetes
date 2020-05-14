#!/bin/bash
set -euo pipefail

kapp deploy -a nfs-client-provisioner --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/nfs-client-provisioner/rendered.yml \
    -f config/nfs-client-provisioner-namespace.yml \
    -f overlays/nfs-client-provisioner-storage-class-default.yml \
    -f overlays/nfs-client-provisioner-namespace.yml \
    -f overlays/nfs-client-provisioner-deployment.yml \
    -f values.yml \
    $@)