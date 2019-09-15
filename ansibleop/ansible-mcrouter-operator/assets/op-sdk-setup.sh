#!/bin/bash

echo "install openshift client"
yum --enablerepo=extras install epel-release -y
yum install python-pip -y
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade pip
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade setuptools
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --ignore-installed ipaddress openshift

echo "install ansible runner -> this will be used for operator-sdk local installs"
yum install python-devel -y
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible-runner
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible-runner-http

echo "setup GoLang Environment"
wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz -P /tmp
tar -C /usr/local -xzf /tmp/go1.10.linux-amd64.tar.gz
echo "export GOPATH=$HOME/tutorial/go" >> ~/.bashrc
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
. ~/.bashrc

echo "install dep"
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

#ensure needed dirs exists at GOPATH
mkdir -p $GOPATH/{src,pkg,bin}

echo "install Operator sdk"
mkdir -p $GOPATH/bin/github.com/operator-framework
cd $GOPATH/bin/github.com/operator-framework
wget https://github.com/operator-framework/operator-sdk/releases/download/v0.2.0/operator-sdk-v0.2.0-x86_64-linux-gnu -O operator-sdk
chmod +x operator-sdk
git config --global user.email "operator-sdk@example.com"
git config --global user.name "OperatorSDK Katacoda"
