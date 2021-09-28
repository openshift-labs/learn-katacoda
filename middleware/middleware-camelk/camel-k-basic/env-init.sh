#!/bin/bash
CAMELK_VERSION=1.4.0

wget https://mirror.openshift.com/pub/openshift-v4/clients/camel-k/$CAMELK_VERSION/camel-k-client-$CAMELK_VERSION-linux-64bit.tar.gz \
    -O - | tar -xz -C /usr/bin/ ./kamel
