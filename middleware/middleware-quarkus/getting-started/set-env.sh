#!/bin/bash

mkdir -p /root/projects/quarkus
cd /root/projects/quarkus

mkdir -p /root/.m2
cat > ~/.m2/settings.xml <<-EOF1
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      https://maven.apache.org/xsd/settings-1.0.0.xsd">
    <localRepository>/root/.m2/repository</localRepository>
    <interactiveMode>false</interactiveMode>
    <profiles>
        <profile>
            <id>jboss-enterprise-maven-repository-ga</id>
            <repositories>
                <repository>
                    <id>jboss-enterprise-maven-repository-ga</id>
                    <url>https://maven.repository.redhat.com/ga/</url>
                    <releases>
                    <enabled>true</enabled>
                    </releases>
                    <snapshots>
                    <enabled>false</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>jboss-enterprise-maven-repository-ga</id>
                    <url>https://maven.repository.redhat.com/ga/</url>
                    <releases>
                    <enabled>true</enabled>
                    </releases>
                    <snapshots>
                    <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
        <profile>
            <id>jboss-enterprise-maven-repository-earlyaccess</id>
            <repositories>
                <repository>
                    <id>jboss-enterprise-maven-repository-ea</id>
                    <url>https://maven.repository.redhat.com/earlyaccess/</url>
                   <releases>
                    <enabled>true</enabled>
                    </releases>
                    <snapshots>
                    <enabled>false</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>jboss-enterprise-maven-repository-ea</id>
                    <url>https://maven.repository.redhat.com/earlyaccess/</url>
                    <releases>
                    <enabled>true</enabled>
                    </releases>
                    <snapshots>
                    <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>
    <activeProfiles>
        <activeProfile>jboss-enterprise-maven-repository-ga</activeProfile>
        <!--<activeProfile>jboss-enterprise-maven-repository-earlyaccess</activeProfile>-->
    </activeProfiles>
</settings>
EOF1

wget -O /tmp/graalvm.tar.gz https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0.2/graalvm-ce-java11-linux-amd64-21.0.0.2.tar.gz && \
pushd /usr/local && \
tar -xvzf /tmp/graalvm.tar.gz && \
rm -rf /tmp/graalvm.tar.gz && \
GRAALVM_HOME="/usr/local/graalvm-ce-java11-21.0.0.2" && \
$GRAALVM_HOME/bin/gu install native-image && \
echo "export GRAALVM_HOME=$GRAALVM_HOME" >> ~/.bashrc && \
popd

wget -O /tmp/jdk.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.10_9.tar.gz && \
pushd /usr/local && \
tar -xvzf /tmp/jdk.tar.gz && \
rm -rf /tmp/jdk.tar.gz && \
JAVA_HOME="/usr/local/jdk-11.0.10+9" && \
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc && \
echo "export PATH=$JAVA_HOME/bin:\$PATH" >> ~/.bashrc && \
popd

clear
