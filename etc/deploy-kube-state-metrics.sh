#!/bin/bash
set -euo pipefail

kapp deploy -a kube-state-metrics --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/kube-state-metrics/rendered.yml \
    $@)