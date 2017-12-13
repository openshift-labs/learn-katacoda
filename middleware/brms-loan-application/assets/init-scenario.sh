#/bin/bash
echo "Initialing environment... This may take a couple of moments."
echo

#Wait for the brms image to be pulled
echo "Waiting for BRMS Docker Image to be pulled."
until docker images duncandoyle/jboss-brms | grep "6.4"; do  echo -n . && sleep 5; done
echo

#Wait for Container image to start
echo "Waiting for BRMS Docker Container to start"
until docker ps | grep "jboss-brms"; do echo -n . && sleep 5; done
echo

#Wait for BRMS workbench availability
echo "Waiting for the BRMS workbench to become available"
until [ $(curl -sL -w "%{http_code}\\n" "http://localhost:8080/business-central" -o /dev/null) == 200 ]; do echo -n . && sleep 5; done
echo

echo "Logging into OpenShift with 'developer' account."
oc login -u developer -p developer
echo

echo "Enviroment ready!"
