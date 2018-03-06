#!/usr/bin/env bash
until $(oc status &> /dev/null); do
  sleep 1
done
echo -n "Configuring admin... "
for i in {1..10}; do oc adm policy add-cluster-role-to-user cluster-admin admin > /dev/null 2>&1 && break || sleep 1; done
echo "Scenario Ready!"
