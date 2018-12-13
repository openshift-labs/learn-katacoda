#switch user to tutorial directory
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
mv /root/tutorial/go/src/github.com/operator-framework/operator-sdk /root/tutorial/go/bin/operator-sdk
cd ~/tutorial
#sleep 20
#source /root/.bashrc