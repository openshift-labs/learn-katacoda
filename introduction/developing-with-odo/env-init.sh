export VERSION="0.0.3"

ssh root@host01 "curl -L 'https://github.com/redhat-developer/ocdev/releases/download/v$VERSION/ocdev-linux-amd64.gz' | gzip -d > /usr/local/bin/ocdev; chmod +x /usr/local/bin/ocdev"
ssh root@host01 "echo 'source <(ocdev completion bash)' >> .bashrc"
