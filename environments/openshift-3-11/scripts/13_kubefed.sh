#!/bin/bash
export KUBEFED_VERSION='v0.0.10'
curl -LOs https://github.com/kubernetes-sigs/kubefed/releases/download/${KUBEFED_VERSION}/kubefedctl.tgz
tar xzf kubefedctl.tgz -C /usr/local/bin
chmod +x /usr/local/bin/kubefedctl
rm -f kubefedctl.tgz
