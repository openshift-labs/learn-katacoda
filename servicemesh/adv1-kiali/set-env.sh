/usr/local/bin/launch.sh
until $(oc get project istio-system &> /dev/null); do sleep 1; done
until (oc get pods -n tutorial -l app=recommendation 2>/dev/null | grep Running); do sleep 1; done
export PATH=$PATH:/root/installation/istio-1.0.5/bin/
