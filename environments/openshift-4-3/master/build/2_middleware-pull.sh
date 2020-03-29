sudo podman pull fabric8/java-jboss-openjdk8-jdk:1.3.1
sudo podman pull fabric8/java-jboss-openjdk8-jdk:1.5.1
sudo podman pull fabric8/java-jboss-openjdk8-jdk:1.5.2
sudo podman pull fabric8/java-jboss-openjdk8-jdk:1.5.4
sudo podman pull docker.io/postgres:10.5
sudo podman pull registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5
sudo podman pull quay.io/quarkus/ubi-quarkus-native-binary-s2i:19.2.0

sudo podman pull registry.access.redhat.com/jboss-eap-7/eap70-openshift
sudo podman pull registry.access.redhat.com/jboss-fuse-6/fis-java-openshift
sudo podman pull registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat8-openshift
sudo podman pull registry.access.redhat.com/jboss-amq-6/amq63-openshift
sudo podman pull registry.access.redhat.com/redhat-sso-7/sso71-openshift
sudo podman pull registry.access.redhat.com/rhoar-nodejs/nodejs-8

# OpenJDK
sudo podman pull registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
sudo podman pull fabric8/java-jboss-openjdk8-jdk:1.3.1

# Red Hat JBoss DataGrid
sudo podman pull registry.access.redhat.com/jboss-datagrid-7/datagrid71-openshift
sudo podman pull registry.access.redhat.com/jboss-datagrid-7/datagrid71-client-openshift

# Red Hat JBoss DataVirt
sudo podman pull registry.access.redhat.com/jboss-datavirt-6/datavirt63-openshift
sudo podman pull registry.access.redhat.com/jboss-datavirt-6/datavirt63-driver-openshift

# Red Hat JBoss BRMS
sudo podman pull registry.access.redhat.com/jboss-decisionserver-6/decisionserver64-openshift

# Red Hat JBoss BPM Suite
sudo podman pull registry.access.redhat.com/jboss-processserver-6/processserver64-openshift

# Red Hat Decision Manager
sudo podman pull registry.access.redhat.com/rhdm-7/rhdm70-decisioncentral-openshift:1.1
sudo podman pull registry.access.redhat.com/rhdm-7/rhdm70-kieserver-openshift:1.1
sudo podman pull registry.access.redhat.com/rhdm-7/rhdm72-decisioncentral-openshift:1.1
sudo podman pull registry.access.redhat.com/rhdm-7/rhdm72-kieserver-openshift:1.1

# Red Hat Process Automation Manager
sudo podman pull registry.access.redhat.com/rhpam-7/rhpam72-businesscentral-openshift:1.1
sudo podman pull registry.access.redhat.com/rhpam-7/rhpam72-kieserver-openshift:1.1

# Strimzi & Debezium
STRIMZI_VERSION=0.14.0
KAFKA_VERSION=2.3.0
DEBEZIUM_VERSION=0.10
sudo podman pull debezium/example-mysql:$DEBEZIUM_VERSION
sudo podman pull strimzi/operator:$STRIMZI_VERSION
sudo podman pull strimzi/kafka:$STRIMZI_VERSION-kafka-$KAFKA_VERSION