yum install -y nc
yum install -y vim man curl wget unzip zip git zsh tmux java-1.8.0-openjdk-devel tree git bash-completion net-tools python36 glibc-langpack-en rsync

export MVN_VERSION=3.6.2
export KAMEL_VERSION=1.0.0-RC1
export KOGITO_VERSION=0.7.0

RUN wget http://www.eu.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz && \
	tar xzf apache-maven-$MVN_VERSION-bin.tar.gz && \
	rm -rf apache-maven-$MVN_VERSION-bin.tar.gz && \
	mkdir /usr/local/maven && \
	mv apache-maven-$MVN_VERSION/ /usr/local/maven/ && \
	alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-$MVN_VERSION/bin/mvn 1

curl -o /usr/local/bin/kubectl http://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl && chmod a+x /usr/local/bin/kubectl

curl -o oc.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.2/linux/oc.tar.gz && \
    tar -xvf oc.tar.gz && \
    rm -f oc.tar.gz && \
    mv oc /usr/bin/oc && \
    chmod +x /usr/bin/oc

curl -o odo.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/odo/v1.0.0/odo-linux-amd64.tar.gz && \
    tar -xvf odo.tar.gz && \
    rm -f odo.tar.gz && \
    mv odo /usr/bin/odo && \
    chmod +x /usr/bin/odo

curl -o kn.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/serverless/0.2.3/kn-linux-amd64-0.2.3.tar.gz && \
    tar -xvf kn.tar.gz && \
    rm -f kn.tar.gz && \
    mv kn-linux-amd64 /usr/bin/kn && \
    chmod +x /usr/bin/kn

curl -o kamel.tar.gz -L https://github.com/apache/camel-k/releases/download/$KAMEL_VERSION/camel-k-client-$KAMEL_VERSION-linux-64bit.tar.gz && \
    tar -xvf kamel.tar.gz && \
    rm -f kamel.tar.gz && \
    mv kamel /usr/bin/kamel && \
    chmod +x /usr/bin/kamel

curl -o kogito.tar.gz -L https://github.com/kiegroup/kogito-cloud-operator/releases/download/v$KOGITO_VERSION/kogito-$KOGITO_VERSION-linux-amd64.tar.gz && \
    tar -xvf kogito.tar.gz && \
    rm -f kogito.tar.gz && \
    mv kogito /usr/bin/kogito && \
    chmod +x /usr/bin/kogito    