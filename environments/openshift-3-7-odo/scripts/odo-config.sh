#!/bin/bash

# download modified odo
wget -O /usr/local/bin/odo https://dl.bintray.com/odo/odo/latest/odo; chmod +x /usr/local/bin/odo

yum install -y bash-completion

echo 'source <(odo completion bash)' >> /root/.bashrc

git clone https://github.com/marekjelen/katacoda-odo-backend.git /root/backend
git clone https://github.com/marekjelen/katacoda-odo-frontend.git /root/frontend

cd /root/backend
mvn package
