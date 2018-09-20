docker pull registry.access.redhat.com/jboss-eap-7/eap70-openshift
docker pull registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
docker pull registry.access.redhat.com/jboss-fuse-6/fis-java-openshift
docker pull registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat8-openshift
docker pull registry.access.redhat.com/jboss-decisionserver-6/decisionserver64-openshift
docker pull registry.access.redhat.com/jboss-processserver-6/processserver64-openshift
docker pull registry.access.redhat.com/jboss-datagrid-7/datagrid71-openshift
docker pull registry.access.redhat.com/jboss-datagrid-7/datagrid71-client-openshift
docker pull registry.access.redhat.com/jboss-datavirt-6/datavirt63-openshift
docker pull registry.access.redhat.com/jboss-datavirt-6/datavirt63-driver-openshift
docker pull registry.access.redhat.com/jboss-amq-6/amq63-openshift
docker pull registry.access.redhat.com/redhat-sso-7/sso71-openshift
docker pull registry.access.redhat.com/rhdm-7/rhdm70-decisioncentral-openshift:1.1
docker pull registry.access.redhat.com/rhdm-7/rhdm70-kieserver-openshift:1.1
docker pull registry.access.redhat.com/rhoar-nodejs/nodejs-8

# Requires RHEL subscription
# docker pull registry.access.redhat.com/jboss-fuse-6/fis-karaf-openshift

curl -k -L -o /opt/jboss-image-streams.json https://raw.githubusercontent.com/redhat-middleware-hackathon/openshift-files/master/jboss-image-streams.json
