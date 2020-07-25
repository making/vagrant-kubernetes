#!/bin/bash

set -exuo pipefail

KUBERNETES_VERSION=1.18.3-00

VAGRANT_PROVISION=/var/vagrant/provison

if [ ! -f ${VAGRANT_PROVISION}/k8s-repo ];then
  echo "==== Setup k8s repo ===="
  # install kubernetes repository
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
  sudo apt-get update -y
  touch ${VAGRANT_PROVISION}/k8s-repo
  echo "==== Finish install k8s repo ===="
fi

if [ ! -f ${VAGRANT_PROVISION}/k8s-${KUBERNETES_VERSION} ];then
  echo "==== Start install k8s-${KUBERNETES_VERSION} ===="
  
  # install lecagy binary
  sudo apt-get install -y iptables arptables ebtables
  
  # install kubeadm, kubelet, kubectl
  sudo apt-get install -y kubelet=${KUBERNETES_VERSION} kubeadm=${KUBERNETES_VERSION} kubectl=${KUBERNETES_VERSION}
  sudo apt-mark hold kubelet kubeadm kubectl
  
  sudo systemctl daemon-reload
  touch ${VAGRANT_PROVISION}/k8s-${KUBERNETES_VERSION}
  echo "==== Finish install k8s-${KUBERNETES_VERSION} ===="
fi

touch /etc/default/kubelet
KUBELET_MD5=$(md5sum /etc/default/kubelet | cut -d " " -f 1)

# get private network IP addr and set bind it to kubelet
IPADDR=$(ip a show enp0s9 | grep inet | grep -v inet6 | awk '{print $2}' | cut -f1 -d/)
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=${IPADDR} --read-only-port=10255
EOF

if [ "$(md5sum /etc/default/kubelet | cut -d " " -f 1)" != "${KUBELET_MD5}" ];then
  echo "Restarting Kubelet"
  # restart kubelet
  sudo systemctl restart kubelet
fi
