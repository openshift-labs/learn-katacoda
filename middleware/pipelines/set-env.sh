# Helps to address error: x509: certificate signed by unknown authority
launch.sh
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1

# Fixes Pipelines Operator issue
oc login -u admin -p admin https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1
oc scale --replicas=1 deployment network-operator -n openshift-network-operator

oc login -u developer -p developer https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1



#This should be provided by the client - should be safe to delete
TKN_INSTALLED=$(tkn version | head -n 1)
if [ -n "$TKN_INSTALLED" ]
then
  echo "TKN $TKN_INSTALLED"
else
  export TKN_VERSION=0.17.2
  echo "Installing tkn version: $TKN_VERSION"
  curl -o tkn.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/$TKN_VERSION/tkn-linux-amd64-$TKN_VERSION.tar.gz && \
    tar -xvf tkn.tar.gz && \
    rm -f tkn.tar.gz LICENSE && \
    mv tkn /usr/bin/tkn && \
    chmod +x /usr/bin/tkn
fi

clear

echo -e "Welcome to your interactive environment. OpenShift is configured and ready to use."
