#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison

if [ ! -f ${VAGRANT_PROVISION}/join-worker ];then
  echo "==== Start join-worker ===="
  /share/join-worker.sh
  touch ${VAGRANT_PROVISION}/join-worker
  echo "==== Finish join-worker ===="
fi

if [ ! -f ${VAGRANT_PROVISION}/nfs-common ];then
  echo "==== Start nfs-common ===="
  sudo apt-get install -y nfs-common
  touch ${VAGRANT_PROVISION}/nfs-common
  echo "==== Finish nfs-common ===="
fi
