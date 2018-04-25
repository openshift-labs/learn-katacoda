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
docker pull projectodd/action-swift-3:${PROJECTODD_VERSION}
docker pull projectodd/controller:${OPENWHISK_VERSION}
docker pull projectodd/invoker:${OPENWHISK_VERSION}
docker pull projectodd/whisk_alarms:${PROJECTODD_VERSION}
docker pull projectodd/whisk_catalog:da00e0c
docker pull projectodd/whisk_couchdb:${PROJECTODD_VERSION}
docker pull strimzi/cluster-controller:${STRIMZI_VERSION}
docker pull strimzi/kafka:${STRIMZI_VERSION}
docker pull strimzi/zookeeper:${STRIMZI_VERSION}