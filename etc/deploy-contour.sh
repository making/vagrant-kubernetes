#!/bin/bash
set -euo pipefail

kapp deploy -a contour --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/contour/examples/contour/00-common.yaml \
    -f vendor/contour/examples/contour/01-contour-config.yaml \
    -f vendor/contour/examples/contour/01-crds.yaml \
    -f vendor/contour/examples/contour/02-job-certgen.yaml \
    -f vendor/contour/examples/contour/02-rbac.yaml \
    -f vendor/contour/examples/contour/02-service-contour.yaml \
    -f vendor/contour/examples/contour/02-service-envoy.yaml \
    -f vendor/contour/examples/contour/03-contour.yaml \
    -f vendor/contour/examples/contour/03-envoy.yaml \
    -f overlays/contour-nodeport.yml \
    -f overlays/contour-inlets-client-sidecer.yml \
    -f values.yml \
    $@)