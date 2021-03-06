#!/bin/bash

set -exuo pipefail

CALICO_VERSION=v3.13
METRICS_SERVER_VERSION=v0.3.6

IPADDR=$(ip a show enp0s8 | grep inet | grep -v inet6 | awk '{print $2}' | cut -f1 -d/)

VAGRANT_PROVISION=/var/vagrant/provison

if [ ! -f ${VAGRANT_PROVISION}/kubeadm-init ];then
  echo "==== Start kubeadm init ===="
  sudo kubeadm init \
    --control-plane-endpoint="${IPADDR}:6443" \
    --apiserver-advertise-address="${IPADDR}" \
    --apiserver-cert-extra-sans="*.sslip.io,*.maki.lol" \
    --kubernetes-version="v1.17.4" \
    --pod-network-cidr="10.200.0.0/16" \
    --upload-certs

  mkdir -p /root/.kube
  sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

  mkdir -p /home/vagrant/.kube
  sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
  sudo chown vagrant:vagrant /home/vagrant/.kube/config

  echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
  touch ${VAGRANT_PROVISION}/kubeadm-init
  echo "==== Finish kubeadm init ===="
fi

kubectl apply -f https://docs.projectcalico.org/${CALICO_VERSION}/manifests/calico.yaml

curl -sL https://github.com/kubernetes-sigs/metrics-server/releases/download/${METRICS_SERVER_VERSION}/components.yaml | \
  ytt --ignore-unknown-comments \
      -f - \
      -f /vagrant/scripts/metrics-server-patch.yml | \
  kubectl apply -f -

cat <<EOF | tee /share/join-worker.sh
#!/bin/bash
sudo $(kubeadm token create --print-join-command)
EOF
chmod +x /share/join-worker.sh 
