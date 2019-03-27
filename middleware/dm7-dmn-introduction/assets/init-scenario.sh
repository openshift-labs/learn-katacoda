#/bin/bash
echo "Initializing environment... This may take a couple of moments."
echo

#Wait for Decision Central OpenShift deployment
echo "Waiting for the Red Hat Decision Manager workbench OpenShift Container to start"
until oc project dmn-demo &>2; do echo -n . && sleep 5; done
until oc get dc/dmn-demo-rhdmcentr &>2; do echo -n . && sleep 5; done
oc rollout status "dc/dmn-demo-rhdmcentr" -n dmn-demo
echo

#Wait for Decision Manager workbench availability
echo "Waiting for the Red Hat Decision Manager workbench to become available"
export DC_HOST=$(oc describe route "dmn-demo-rhdmcentr" | grep "Requested Host" | sed 's/Requested Host://' | tr -d '[:blank:]')
#until [ $(curl -sL -w "%{http_code}\\n" "http://$DC_HOST/kie-drools-wb.jsp" -o /dev/null) == 200 ]; do echo -n . && sleep 5; done
until curl -s http://$DC_HOST/kie-drools-wb.jsp | grep -q "Decision"; do echo -n . && sleep 5; done
echo

echo "Enviroment ready!"
