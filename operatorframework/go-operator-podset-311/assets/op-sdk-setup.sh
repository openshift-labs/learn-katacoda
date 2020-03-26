#!/bin/bash

#install openshift client
yum install python-pip -y
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade pip
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade setuptools
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --ignore-installed ipaddress openshift

#install ansible runner -> this will be used for operator-sdk local installs
yum install python-devel -y
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible-runner
pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org ansible-runner-http

#setup GoLang Environment
#yum install go -y
#echo "export GOPATH=$HOME/tutorial/go" >> ~/.bashrc
#echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc && mkdir -p $GOPATH/bin
#echo "export GOROOT=/usr/lib/golang" >> ~/.bashrc
#echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc
#. ~/.bashrc

#setup GoLang Environment
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -xzf go1.10.3.linux-amd64.tar.gz
mv go /usr/local
echo "export GOPATH=$HOME/tutorial/go" >> ~/.bashrc
echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc && mkdir -p $GOPATH/bin
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc
. ~/.bashrc

#install dep
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

#install Operator sdk
mkdir -p $GOPATH/src/github.com/operator-framework
cd $GOPATH/src/github.com/operator-framework
git clone https://github.com/operator-framework/operator-sdk
cd operator-sdk
git checkout master
make dep
make install