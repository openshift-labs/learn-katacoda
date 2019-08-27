#!/bin/bash

echo "**** Installing ODO using binary file ****"

curl -L https://github.com/openshift/odo/releases/download/v1.0.0-beta2/odo-linux-amd64 -o /usr/local/bin/odo && chmod +x /usr/local/bin/odo
curl -L -o /opt/lets-encrypt-x3-cross-signed.pem https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem 
