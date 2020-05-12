# vagrant-kubernetes

Bootstraping the following Kubernetes cluster

* master x 1 (2 cpu, 2GB RAM)
* worker x 3 (2 cpu, 4GB RAM)
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
vagrant ssh master -c 'cat $HOME/.kube/config' > kubconfig-vagrant.yml
KUBECONFIG=${PWD}/kubconfig-vagrant.yml
kubectl get nodes -o wide
```
