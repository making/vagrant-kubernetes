#!/bin/bash
set -euo pipefail

kapp deploy -a metallb --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/metallb/manifests/namespace.yaml \
    -f vendor/metallb/manifests/metallb.yaml \
    -f config/metallb-secret.yml \
    -f config/metallb-configmap.yml \
    -f values.yml \
    $@)