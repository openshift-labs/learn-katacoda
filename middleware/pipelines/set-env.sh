#Helps to address error: x509: certificate signed by unknown authority
launch.sh
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
oc login -u developer -p developer https://master:8443 --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

# Get the tar.xz for tekton CLI
curl -LO https://github.com/tektoncd/cli/releases/download/v0.6.0/tkn_0.6.0_Linux_x86_64.tar.gz
# Extract tkn to your PATH (e.g. /usr/local/bin)
tar xvzf tkn_0.6.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn

clear

echo -e "Welcome to your interactive environment. OpenShift is configured and ready to use."
