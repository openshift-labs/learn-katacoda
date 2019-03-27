/usr/local/bin/launch.sh
until $(oc get project istio-system &> /dev/null); do sleep 1; done
mkdir -p ~/projects/ && cd ~/projects/
export PATH=$PATH:/root/installation/istio-1.0.5/bin
