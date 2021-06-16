
echo "Configuring scenario"
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
launch.sh
oc login -u developer -p developer https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

clear

echo "Setting up the environment"

mkdir -p /data/pv-01 /data/pv-02 /data/pv-03
chmod 0777 /data/pv-*; chcon -t svirt_sandbox_file_t /data/pv-*;

clear

echo "Cloning app repos"
git clone https://github.com/openshift-evangelists/Wild-West-Backend.git ~/backend > /dev/null 2>&1
git clone https://github.com/openshift-evangelists/Wild-West-Frontend.git ~/frontend > /dev/null 2>&1

clear

# Check to see if odo needs to be updated

# It *should* be safe to delete this section,
# as odo should already be installed via the client, here:
# https://github.com/openshift-labs/learn-katacoda/blob/master/environments/openshift-4-7/client/build/1_packages.sh#L27-L31

odo preference set -f ConsentTelemetry false > /dev/null 2>&1
ODO_INSTALL="latest"
ODO_RESPONSE=$(odo version 2> /dev/null)
ODO_VERSION=${ODO_RESPONSE:0:10}

# Test to make sure the update is needed before proceeding with the install:
if [[ -z $ODO_VERSION || $ODO_VERSION == "odo v1.0.0" ]]; then
  curl -o odo.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/odo/$ODO_INSTALL/odo-linux-amd64.tar.gz && \
    tar -xvf odo.tar.gz && \
    rm -f odo.tar.gz && \
    mv -f odo /usr/bin/odo && \
    chmod +x /usr/bin/odo && \
    odo preference set -f ConsentTelemetry false > /dev/null 2>&1
fi

odo preference set UpdateNotification false > /dev/null 2>&1

clear

echo "Configuration completed"
