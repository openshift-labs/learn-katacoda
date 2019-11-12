import os

# Construct service account name for use as the OAuth client ID.

service_account_name = '%s-hub' %  application_name

with open(os.path.join(service_account_path, 'namespace')) as fp:
    namespace = fp.read().strip()

client_id = 'system:serviceaccount:%s:%s' % (namespace, service_account_name)

# Use the REST API service access token as the client secret.

with open(os.path.join(service_account_path, 'token')) as fp:
    client_secret = fp.read().strip()

# Configure the OAuth authenticator handler for OpenShift. Note that the
# environment variables it requires are set up from jupyterhub_config.sh
# as JupyterHub 1.0+ no longer allows the environment variables to be set
# in the jupyterhub_config.py file.

#c.JupyterHub.authenticator_class = "openshift"

from oauthenticator.openshift import OpenShiftOAuthenticator
c.JupyterHub.authenticator_class = OpenShiftOAuthenticator

c.OpenShiftOAuthenticator.client_id = client_id
c.OpenShiftOAuthenticator.client_secret = client_secret

c.OpenShiftOAuthenticator.oauth_callback_url = (
        'https://%s/hub/oauth_callback' % public_hostname)
