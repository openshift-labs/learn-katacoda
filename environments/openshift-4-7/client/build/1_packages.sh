yum install -y nc
yum install -y vim man curl wget unzip zip git zsh tmux java-1.8.0-openjdk-devel tree git bash-completion net-tools python36 glibc-langpack-en rsync

export MVN_VERSION=3.8.1
export CAMEL_K_VERSION=1.3.0
export HELM_VERSION=latest
export ODO_VERSION=latest
export KN_VERSION=latest
export TKN_VERSION=0.17.2
export KOGITO_VERSION=0.17.0

wget http://www.eu.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz && \
    tar xzf apache-maven-$MVN_VERSION-bin.tar.gz && \
    rm -rf apache-maven-$MVN_VERSION-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    mv apache-maven-$MVN_VERSION/ /usr/local/maven/ && \
    alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-$MVN_VERSION/bin/mvn 1

curl -o camel_k.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/camel-k/$CAMEL_K_VERSION/camel-k-client-$CAMEL_K_VERSION-linux-64bit.tar.gz && \
    tar -xvf camel_k.tar.gz && \
    rm -f camel_k.tar.gz kamel.asc kamel.sha512 && \
    mv kamel /usr/bin/kamel && \
    chmod +x /usr/bin/kamel

curl -o /usr/local/bin/helm https://mirror.openshift.com/pub/openshift-v4/clients/helm/$HELM_VERSION/helm-linux-amd64 && chmod a+x /usr/local/bin/helm

curl -o odo.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/odo/$ODO_VERSION/odo-linux-amd64.tar.gz && \
    tar -xvf odo.tar.gz && \
    rm -f odo.tar.gz && \
    mv odo /usr/bin/odo && \
    chmod +x /usr/bin/odo

curl -o tkn.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/$TKN_VERSION/tkn-linux-amd64-$TKN_VERSION.tar.gz && \
    tar -xvf tkn.tar.gz && \
    rm -f tkn.tar.gz && \
    mv tkn /usr/bin/tkn && \
    chmod +x /usr/bin/tkn

curl -o kn.tar.gz -L https://mirror.openshift.com/pub/openshift-v4/clients/serverless/$KN_VERSION/kn-linux-amd64.tar.gz && \
    tar -xvf kn.tar.gz && \
    rm -f kn.tar.gz && \
    mv kn /usr/bin/kn && \
    chmod +x /usr/bin/kn

curl -o kogito.tar.gz -L https://github.com/kiegroup/kogito-cloud-operator/releases/download/v$KOGITO_VERSION/kogito-cli-$KOGITO_VERSION-linux-amd64.tar.gz && \
    tar -xvf kogito.tar.gz && \
    rm -f kogito.tar.gz && \
    mv kogito /usr/bin/kogito && \
    chmod +x /usr/bin/kogito

