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
