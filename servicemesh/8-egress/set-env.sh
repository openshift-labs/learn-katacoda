~/.launch.sh
echo "Waiting istio installation to complete for this scenario"
until $(oc get project istio-system &> /dev/null); do sleep 1; done
export PATH=$PATH:/root/installation/istio-0.6.0/bin/
