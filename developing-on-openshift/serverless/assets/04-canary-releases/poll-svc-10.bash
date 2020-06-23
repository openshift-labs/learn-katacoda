#!/usr/bin/env bash
for run in {1..10}
do
  curl http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
done