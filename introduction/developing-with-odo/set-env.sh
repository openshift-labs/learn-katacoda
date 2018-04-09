~/.launch.sh

export ODO_VERSION="0.0.3"

curl -k -L "https://github.com/redhat-developer/ocdev/releases/download/v${ODO_VERSION}/ocdev-linux-amd64.gz" | gzip -d > /usr/local/bin/ocdev; chmod +x /usr/local/bin/ocdev
echo 'source <(ocdev completion bash)' >> .bashrc

git clone https://github.com/marekjelen/katacoda-odo-frontend.git frontend

exec /bin/bash
