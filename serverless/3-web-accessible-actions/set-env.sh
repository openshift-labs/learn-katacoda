#!/bin/bash
export PATH="/root/openwhisk/bin:${PATH}"
# We need the sleep below so that there is time for the asset to be copied over.
sleep 1
/root/setup-environment.sh
