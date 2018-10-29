#!/usr/bin/env bash

VAULT=0.11.4

which vault &>/dev/null || {
  pushd /usr/local/bin
  [ -f vault_${VAULT}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_amd64.zip
  }
  sudo unzip vault_${VAULT}_linux_amd64.zip
  sudo chmod +x vault
  popd
}
