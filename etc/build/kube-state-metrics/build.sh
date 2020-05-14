#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "Generating kube-state-metric resource definitions..."

helm template kube-state-metrics --namespace=kube-system "${SCRIPT_DIR}/_vendir/stable/kube-state-metrics/" |
  ytt --ignore-unknown-comments -f - |
  kbld -f - \
  > "${SCRIPT_DIR}/../../vendor/kube-state-metrics/rendered.yml"