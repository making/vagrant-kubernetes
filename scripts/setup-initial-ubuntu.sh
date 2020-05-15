#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison

if [ ! -d ${VAGRANT_PROVISION} ];then
  echo "==== Create ${VAGRANT_PROVISION} ===="
  # set timezone
  sudo timedatectl set-timezone Asia/Tokyo
  
  # update all
  sudo apt-get update -y
  sudo apt-get upgrade -y
  mkdir -p ${VAGRANT_PROVISION}
fi

if [ ! -f ${VAGRANT_PROVISION}/k14s ];then
  echo "==== Start installing k14s ===="
  curl -L https://k14s.io/install.sh | bash
  touch ${VAGRANT_PROVISION}/k14s
  echo "==== Finish installing k14s ===="
fi
