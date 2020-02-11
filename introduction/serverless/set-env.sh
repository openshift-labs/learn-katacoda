
echo "Configuring scenario"
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
launch.sh
oc login -u developer -p developer https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

clear

echo "Setting up the environment"

mkdir -p /data/pv-01 /data/pv-02 /data/pv-03
chmod 0777 /data/pv-*; chcon -t svirt_sandbox_file_t /data/pv-*;

clear

echo "Setting up kn CLI"
mkdir .kn
curl -Lo .kn/kn-linux-amd64-0.11.0.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/serverless/0.11.0/kn-linux-amd64-0.11.0.tar.gz
tar xf .kn/kn-linux-amd64-0.11.0.tar.gz -C .kn
ln -s .kn/kn /usr/local/bin/kn
rm -f .kn/kn-linux-amd64-0.11.0.tar.gz

clear

echo "Configuration completed!!"
