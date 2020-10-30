docker pull registry.access.redhat.com/jboss-eap-7/eap70-openshift
docker pull registry.access.redhat.com/jboss-fuse-6/fis-java-openshift
docker pull registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat8-openshift
docker pull registry.access.redhat.com/jboss-amq-6/amq63-openshift
docker pull registry.access.redhat.com/redhat-sso-7/sso71-openshift
docker pull registry.access.redhat.com/rhoar-nodejs/nodejs-8

# OpenJDK
docker pull registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
docker pull fabric8/java-jboss-openjdk8-jdk:1.3.1

# Red Hat JBoss DataGrid
docker pull registry.access.redhat.com/jboss-datagrid-7/datagrid71-openshift
docker pull registry.access.redhat.com/jboss-datagrid-7/datagrid71-client-openshift

# Red Hat JBoss DataVirt
docker pull registry.access.redhat.com/jboss-datavirt-6/datavirt63-openshift
docker pull registry.access.redhat.com/jboss-datavirt-6/datavirt63-driver-openshift

# Strimzi & Debezium
STRIMZI_VERSION=0.14.0
KAFKA_VERSION=2.3.0
DEBEZIUM_VERSION=0.10
docker pull debezium/example-mysql:$DEBEZIUM_VERSION
docker pull strimzi/operator:$STRIMZI_VERSION
docker pull strimzi/kafka:$STRIMZI_VERSION-kafka-$KAFKA_VERSION

# Requires RHEL subscription
# docker pull registry.access.redhat.com/jboss-fuse-6/fis-karaf-openshift

curl -k -L -o /opt/jboss-image-streams.json https://raw.githubusercontent.com/redhat-middleware-hackathon/openshift-files/master/jboss-image-streams.json
