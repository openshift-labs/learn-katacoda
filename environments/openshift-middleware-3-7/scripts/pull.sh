V=v3.7.0
docker pull docker.io/openshift/origin-deployer:$V
docker pull docker.io/openshift/origin-pod:$V
docker pull openshift/origin:$V
docker pull openshift/hello-openshift:latest
docker pull openshift/hello-openshift:$V
docker pull openshift/origin-haproxy-router:$V
docker pull openshift/origin-docker-registry:$V
docker pull openshift/origin-deployer:$V
docker pull openshift/origin-docker-builder:$V
docker pull openshift/origin-sti-builder:$V
docker pull openshift/origin-gitserver:$V
docker pull openshift/mysql-55-centos7:latest
docker pull openshift/origin-metrics-deployer:$V
docker pull openshift/origin-metrics-heapster:$V
docker pull openshift/origin-metrics-cassandra:$V
docker pull openshift/origin-metrics-hawkular-metrics:$V
docker pull openshift/origin-service-catalog:$V
docker pull openshift/base-centos7:latest
docker pull openshift/jenkins-1-centos7:latest
docker pull centos/python-35-centos7:latest
docker pull katacoda/contained-nfs-server:centos7

docker pull openshiftroadshow/parksmap-katacoda:1.0.0

###  OpenWhisk images
PROJECTODD_VERSION=f5eae82
OPENWHISK_VERSION=rhdemo-b7724ef
STRIMZI_VERSION=0.2.0
docker pull busybox
docker pull centos/nginx-112-centos7@sha256:42330f7f29ba1ad67819f4ff3ae2472f62de13a827a74736a5098728462212e7
docker pull openwhisk/alarmprovider:1.9.0
docker pull projectodd/action-java-8:${PROJECTODD_VERSION}
docker pull projectodd/action-nodejs-6:${PROJECTODD_VERSION}
docker pull projectodd/action-nodejs-8:${PROJECTODD_VERSION}
docker pull projectodd/action-php-7:${PROJECTODD_VERSION}
docker pull projectodd/action-python-2:${PROJECTODD_VERSION}
docker pull projectodd/action-python-3:${PROJECTODD_VERSION}
docker pull projectodd/controller:${OPENWHISK_VERSION}
docker pull projectodd/invoker:${OPENWHISK_VERSION}
docker pull projectodd/whisk_alarms:${PROJECTODD_VERSION}
docker pull projectodd/whisk_catalog:da00e0c
docker pull projectodd/whisk_couchdb:${PROJECTODD_VERSION}
docker pull strimzi/cluster-controller:${STRIMZI_VERSION}
docker pull strimzi/kafka:${STRIMZI_VERSION}
docker pull strimzi/zookeeper:${STRIMZI_VERSION}

curl -o ~/openwhisk-template https://git.io/openwhisk-template