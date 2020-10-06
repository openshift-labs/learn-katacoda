#!/usr/bin/env bash
set -o pipefail 
curl -L -o /usr/local/bin/hey https://storage.googleapis.com/hey-release/hey_linux_amd64
chmod +x /usr/local/bin/hey
yum install -y jq
pip3 install yq
