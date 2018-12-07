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
yum install go -y
echo "export GOPATH=$HOME/tutorial/go" >> ~/.bashrc
echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc && mkdir -p $GOPATH/bin
echo "export GOROOT=/usr/lib/golang" >> ~/.bashrc
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc
. ~/.bashrc

echo "install dep"
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

echo "install Operator sdk"
mkdir -p /root/tutorial/go/src/github.com/operator-framework
cd /root/tutorial/go/src/github.com/operator-framework
git clone https://github.com/operator-framework/operator-sdk
cd operator-sdk
git checkout master
make dep
make install
