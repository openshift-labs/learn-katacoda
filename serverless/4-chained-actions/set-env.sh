#!/bin/bash
export PATH="/root/openwhisk/bin:${PATH}"
# We need this sleep to allow the asset to be copied over.
sleep 1
/root/setup-environment.sh
