# This sets up environment variables for "oauthenticator.openshift".

# From OpenShift 4.0 we need to supply separate URLs for Kubernetes
# server and OAuth server.

KUBERNETES_SERVER_URL="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT"

OAUTH_METADATA_URL="$KUBERNETES_SERVER_URL/.well-known/oauth-authorization-server"

OAUTH_ISSUER_ADDRESS=`curl -ks $OAUTH_METADATA_URL | \
    python -c "import json, sys; \
               data = json.loads(sys.stdin.read()); \
               print(data['issuer'])"`

export OPENSHIFT_URL=$OAUTH_ISSUER_ADDRESS
export OPENSHIFT_REST_API_URL=$KUBERNETES_SERVER_URL
export OPENSHIFT_AUTH_API_URL=$OAUTH_ISSUER_ADDRESS
