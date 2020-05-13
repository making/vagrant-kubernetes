# vagrant-kubernetes

Bootstraping the following Kubernetes cluster

* master (2 cpu, 2GB RAM) x 1
* worker (2 cpu, 4GB RAM) x 3 (Configurable)
* CNI: Calico

## Prerequisite

- Vagrant

```
brew cask install vagrant virtualbox virtualbox-extension-pack
```

## How to use

```
git clone https://github.com/making/vagrant-kubernetes.git
mkdir share
vagrant up
```

```
vagrant ssh master-1 -c 'cat $HOME/.kube/config' > kubconfig-vagrant.yml
KUBECONFIG=${PWD}/kubconfig-vagrant.yml
kubectl get nodes -o wide
```


If you want to use the bridge network, comment out following lines and change IP according to your network.

```
       #c.vm.network "public_network", ip: "192.168.11.1#{n}", bridge: "eno1: Ethernet"
```

If your API server is runing on `192.168.11.11`, then you can reach it via `192-168-11-11.sslip.io`. Change the server url in your kubeconfig.