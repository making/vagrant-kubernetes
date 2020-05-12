# Deploy etc ...

```
cp sample-values. values.yml
```

## Deploy [Inlets Operator](https://github.com/inlets/inlets-operator)

Configure `inlets_access_key` for Digital Ocean API Token in `values.yml`

Then

```
./deploy-inlets.sh
```


Deploy [a sample application](https://github.com/inlets/inlets-operator#expose-a-service-with-a-loadbalancer)