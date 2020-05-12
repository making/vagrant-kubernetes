#!/bin/bash
set -euo pipefail

kapp deploy -a inlets --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f config/inlets-namespace.yml \
    -f config/inlets-secret.yml \
    -f vendor/inlets-operator/artifacts \
    -f overlays/inlets-namespace.yml \
    -f overlays/inlets-serviceaccount.yml \
    -f values.yml \
    $@)