#!/usr/bin/env bash

ISTIO_VERSION=0.6.0
ISTIO_HOME=${HOME}/istio-${ISTIO_VERSION}
export PATH="$PATH:${ISTIO_HOME}/bin"

cd ${ISTIO_HOME}

oc project istio-system
istioctl kube-inject -f samples/bookinfo/kube/bookinfo.yaml | oc apply -f -
