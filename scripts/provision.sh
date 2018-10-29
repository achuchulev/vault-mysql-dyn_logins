#!/usr/bin/env bash

VAULT=0.11.4

PKG="wget unzip"
which ${PKG} &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ${PKG}
}

which vault &>/dev/null || {
  pushd /usr/local/bin
  [ -f vault_${VAULT}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_amd64.zip
  }
  sudo unzip vault_${VAULT}_linux_amd64.zip
  sudo chmod +x vault
  popd
}

which jq || {
  apt-get update
  sudo apt-get install -y jq
}
