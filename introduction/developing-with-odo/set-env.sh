
echo "Configuring scenario"

curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
oc login -u developer -p developer https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1
oc apply -f https://gist.githubusercontent.com/jorgemoralespou/033c27a354406d7c5111711346e79b01/raw/000e26a7e736313716e46a11a710fbe2c0cbb791/java-is-insecure.json -n openshift --as system:admin

clear

echo "Setting up the environment"

mkdir -p /data/pv-01 /data/pv-02 /data/pv-03
chmod 0777 /data/pv-*; chcon -t svirt_sandbox_file_t /data/pv-*;

clear

odo utils config set UpdateNotification false > /dev/null 2>&1
oc create -f volumes.json --as system:admin
oc import-image -n openshift java 1> /dev/null --as system:admin
oc import-image -n openshift nodejs 1> /dev/null --as system:admin

clear

echo "Cloning app repos"
git clone https://github.com/openshift-evangelists/Wild-West-Backend.git ~/backend > /dev/null 2>&1
git clone https://github.com/openshift-evangelists/Wild-West-Frontend.git ~/frontend > /dev/null 2>&1

clear

echo "Configuration completed"

