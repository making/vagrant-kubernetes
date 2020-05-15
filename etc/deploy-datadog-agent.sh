#!/bin/bash
set -euo pipefail

kapp deploy -a datadog-agent --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f config/datadog-agent-vanilla.yaml \
    -f config/datadog-namespace.yml \
    -f overlays/datadog-agent-secret.yml \
    -f overlays/datadog-namespace.yml \
    -f values.yml \
    $@)
