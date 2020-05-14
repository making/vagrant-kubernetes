# Deploy etc ...

```
cp sample-values. values.yml
```

## Deploy [Contour](https://github.com/projectcontour/contour)

```
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
    -f overlays/contour-nodeport.yml)
```


If you want to reach apps via Internet, prepare an [Exit server of Inlets](https://blog.alexellis.io/https-inlets-local-endpoints/).
Then configure `inlets_remote` and `inlets_token` in `values.yml`.

```
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
    -f values.yml)
```


## Deploy [Inlets Operator](https://github.com/inlets/inlets-operator)

Configure `digitalocean_access_token` for Digital Ocean API Token in `values.yml`

Then

```
kapp deploy -a inlets --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f config/inlets-namespace.yml \
    -f config/inlets-secret.yml \
    -f vendor/inlets-operator/artifacts \
    -f overlays/inlets-namespace.yml \
    -f overlays/inlets-serviceaccount.yml \
    -f values.yml)
```


Deploy [a sample application](https://github.com/inlets/inlets-operator#expose-a-service-with-a-loadbalancer)