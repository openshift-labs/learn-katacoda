#!/usr/bin/env bash

###  OpenWhisk images
PROJECTODD_LEARN_TAG=learn
docker pull projectodd/busybox:${PROJECTODD_LEARN_TAG}
docker pull projectodd/nginx:${PROJECTODD_LEARN_TAG}
docker pull projectodd/alarmprovider:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-java-8:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-nodejs-6:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-nodejs-8:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-php-7:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-python-2:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-python-3:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-swift-3:${PROJECTODD_LEARN_TAG}
docker pull projectodd/controller:${PROJECTODD_LEARN_TAG}
docker pull projectodd/invoker:${PROJECTODD_LEARN_TAG}
docker pull projectodd/whisk_alarms:${PROJECTODD_LEARN_TAG}
docker pull projectodd/whisk_catalog:${PROJECTODD_LEARN_TAG}
docker pull projectodd/whisk_couchdb:${PROJECTODD_LEARN_TAG}
docker pull projectodd/cluster-controller:${PROJECTODD_LEARN_TAG}
docker pull projectodd/kafka:${PROJECTODD_LEARN_TAG}
docker pull projectodd/zookeeper:${PROJECTODD_LEARN_TAG}

# leave both in for now until the learn template gets merged
# the scenarios can reference /opt/openwhisk-template in the meantime
curl -o /opt/openwhisk-template https://raw.githubusercontent.com/projectodd/openwhisk-openshift/master/template.yml
curl -o /opt/openwhisk-learn-template https://raw.githubusercontent.com/projectodd/openwhisk-openshift/master/learn-template.yml