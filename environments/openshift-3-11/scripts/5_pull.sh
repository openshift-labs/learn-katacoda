export V=v3.11

docker pull ansibleplaybookbundle/origin-ansible-service-broker:$V

docker pull quay.io/coreos/hyperkube:v1.7.6_coreos.0
docker pull docker.io/openshift/origin-web-console:$V
docker pull docker.io/openshift/origin-docker-registry:$V
docker pull docker.io/openshift/origin-haproxy-router:$V
docker pull docker.io/openshift/origin:$V
docker pull docker.io/openshift/origin-service-catalog:$V
docker pull docker.io/openshift/origin-template-service-broker:$V
docker pull quay.io/coreos/etcd

docker pull docker.io/openshift/origin-control-plane:$V
docker pull docker.io/openshift/origin-cli:$V
docker pull docker.io/openshift/origin-node:$V
docker pull docker.io/openshift/origin-deployer:$V
docker pull docker.io/openshift/origin-pod:$V
docker pull docker.io/openshift/origin-hypershift:$V
docker pull docker.io/openshift/origin-hyperkube:$V
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

docker pull ansibleplaybookbundle/origin-ansible-service-broker:$V
