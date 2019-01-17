wget https://github.com/operator-framework/operator-sdk/releases/download/v0.2.1/operator-sdk-v0.2.1-x86_64-linux-gnu -O /root/tutorial/go/bin/operator-sdk
chmod +x /root/tutorial/go/bin/operator-sdk
export GOBIN=/root/tutorial/go/bin
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
#switch user to tutorial directory
cd ~/tutorial
