#!/bin/sh
echo "export PATH=$GRAALVM_HOME/bin:$PATH" >> /root/.bashrc

mkdir -p /root/projects/kogito
cd /root/projects/kogito
clear

# Clone our Coffee service
git clone https://github.com/DuncanDoyle/coffeeservice-quarkus.git /root/projects/kogito/coffeeservice-quarkus
