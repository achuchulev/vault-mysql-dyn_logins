#!/usr/bin/env bash

VAULT=0.11.4

# install some packages
PKG="wget unzip jq vim"
which ${PKG} &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ${PKG}
}

# install vault if not installed
which vault &>/dev/null || {
  pushd /usr/local/bin
  [ -f vault_${VAULT}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_amd64.zip
  }
  sudo unzip vault_${VAULT}_linux_amd64.zip
  sudo chmod +x vault
  popd
}

# check consul-template binary
which consul-template || {
  pushd /usr/local/bin
  [ -f consul-template_${CONSULTEMPLATE}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE}/consul-template_${CONSULTEMPLATE}_linux_amd64.zip
  }
  sudo unzip consul-template_${CONSULTEMPLATE}_linux_amd64.zip
  sudo chmod +x consul-template
  popd
}

# check envconsul binary
which envconsul || {
  pushd /usr/local/bin
  [ -f envconsul_${ENVCONSUL}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/envconsul/${ENVCONSUL}/envconsul_${ENVCONSUL}_linux_amd64.zip
  }
  sudo unzip envconsul_${ENVCONSUL}_linux_amd64.zip
  sudo chmod +x envconsul
  popd
}
