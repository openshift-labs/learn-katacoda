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