#!/bin/bash

echo "install gcc"
yum install gcc -y

echo "install openshift client"
yum --enablerepo=extras install epel-release -y
yum install python2-pip -y
pip2 install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade pip
pip2 install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade setuptools
pip2 install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --ignore-installed ipaddress openshift

echo "install ansible and ansible runner -> this will be used for operator-sdk local installs"
yum install python2-devel -y
pip2 install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible
pip2 install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible-runner
pip2 install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible-runner-http

echo "set kube editor"
echo "export KUBE_EDITOR=vim" >> ~/.bashrc

echo "create tutorial dir"
mkdir -p $HOME/tutorial

echo "setup GoLang Environment"
wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz -P /tmp
tar -C /usr/local -xzf /tmp/go1.13.1.linux-amd64.tar.gz
echo "export GOPATH=$HOME/tutorial/go" >> ~/.bashrc
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
echo "export GO111MODULE=on" >> ~/.bashrc
. ~/.bashrc

echo "install dep"
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

echo "ensure needed dirs exists at GOPATH"
mkdir -p $GOPATH/{src,pkg,bin}

echo "install Operator sdk"
wget https://github.com/operator-framework/operator-sdk/releases/download/v0.15.2/operator-sdk-v0.15.2-x86_64-linux-gnu 
chmod +x operator-sdk-v0.15.2-x86_64-linux-gnu 
mv operator-sdk-v0.15.2-x86_64-linux-gnu /root/tutorial/go/bin/operator-sdk
