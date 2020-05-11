# Install Helm client
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz
tar -zxvf helm-v2.13.1-linux-amd64.tar.gz
mv -f linux-amd64/helm /usr/local/bin/helm
helm init --client-only

# Set GOBIN
export GOBIN=/root/tutorial/go/bin

# Install dep
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# Switch user to tutorial directory
cd ~/tutorial
clear
