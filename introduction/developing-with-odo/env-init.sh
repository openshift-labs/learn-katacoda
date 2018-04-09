export ODO_VERSION="0.0.3"

ssh root@host01 "curl -k -L \"https://github.com/redhat-developer/ocdev/releases/download/v${ODO_VERSION}/ocdev-linux-amd64.gz\" | gzip -d > /usr/local/bin/ocdev; chmod +x /usr/local/bin/ocdev"
ssh root@host01 "echo 'source <(ocdev completion bash)' >> .bashrc"
