
echo "Configuring scenario"
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
launch.sh
oc login -u developer -p developer https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

clear

echo "Setting up the environment"

mkdir -p /data/pv-01 /data/pv-02 /data/pv-03
chmod 0777 /data/pv-*; chcon -t svirt_sandbox_file_t /data/pv-*;

clear

odo preference set UpdateNotification false > /dev/null 2>&1

clear

echo "Cloning app repos"
git clone https://github.com/openshift-evangelists/Wild-West-Backend.git ~/backend > /dev/null 2>&1
git clone https://github.com/openshift-evangelists/Wild-West-Frontend.git ~/frontend > /dev/null 2>&1

clear

echo "Configuration completed"
