echo "Downloading Istio..."
until $(tar -tvf /root/installation/istio-1.0.5-linux.tar.gz &> /dev/null); do (echo -n .; sleep 2); done;
/usr/local/bin/launch.sh
mkdir -p /root/installation && cd ~/installation