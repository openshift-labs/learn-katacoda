#!/bin/bash
python /opt/fix_ocp_katacoda.py
rm -f /opt/fix_ocp_katacoda.py

oc cluster up --host-data-dir=/katacoda/data --host-config-dir=/katacoda/config --host-pv-dir=/katacoda/pv --host-volumes-dir=/katacoda/volumes --use-existing-config

rm -Rf ~/.kube/*
cp /katacoda/config/master/admin.kubeconfig ~/.kube/config
oc scale dc router -n default --replicas=1
oc scale dc docker-registry -n default --replicas=1

