# Deploy etc ...

```
cp sample-values. values.yml
```

## Deploy [Metal LB](https://github.com/metallb/metallb)

Configure `metallb_secret_key` and `metallb_config` in `values.yml`

Then

```
kapp deploy -a metallb --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/metallb/manifests/namespace.yaml \
    -f vendor/metallb/manifests/metallb.yaml \
    -f config/metallb-secret.yml \
    -f config/metallb-configmap.yml \
    -f values.yml)
```

## Deploy [NFS client provisioner](https://github.com/helm/charts/tree/master/stable/nfs-client-provisioner)

Prepare a NFS server in advance. If you have Synology NAS, see [this blog post](https://blog.cowger.us/2018/08/03/nfs-on-synology.html).

Configure `nfs_server` and `nfs_path` in `values.yml`

Then

```
kapp deploy -a nfs-client-provisioner --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/nfs-client-provisioner/rendered.yml \
    -f config/nfs-client-provisioner-namespace.yml \
    -f overlays/nfs-client-provisioner-storage-class-default.yml \
    -f overlays/nfs-client-provisioner-namespace.yml \
    -f overlays/nfs-client-provisioner-deployment.yml \
    -f values.yml)
```

## Deploy [Contour](https://github.com/projectcontour/contour)

> If you haven't installed Metal LB, add `-f overlays/contour-nodeport.yml` to use `NodePort` instead of `LoadBalancer`.

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
    -f vendor/contour/examples/contour/03-envoy.yaml)
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
    -f overlays/contour-inlets-client-sidecer.yml \
    -f values.yml)
```

## Deploy [kube-state-metrics](https://github.com/helm/charts/tree/master/stable/kube-state-metrics)

```
kapp deploy -a kube-state-metrics --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f vendor/kube-state-metrics/rendered.yml)
```

## Deploy [datadog-agent](https://github.com/DataDog/datadog-agent)

Then configure `datadog_api_key` in `values.yml`.

```
kapp deploy -a datadog-agent --diff-changes \
  -f <(ytt --ignore-unknown-comments \
    -f config/datadog-agent-vanilla.yaml \
    -f config/datadog-namespace.yml \
    -f overlays/datadog-agent-secret.yml \
    -f overlays/datadog-namespace.yml \
    -f values.yml)
```


## Deploy [Inlets Operator](https://github.com/inlets/inlets-operator)

> If you have already installed Metal LB, be careful of the configuration conflicts.
> 
> See https://github.com/inlets/inlets-operator#annotations-and-ignoring-services

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