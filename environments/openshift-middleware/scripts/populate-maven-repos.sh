#!/bin/bash

# Uncomment to turn on exit on error
#set -e


# Add additional repos to use to pre-populate the local maven repostiory to the SOURCE_REPOS environment variable. 
# Entries are separated by spaces
SOURCE_REPOS=( https://github.com/openshift-katacoda/rhoar-getting-started.git )
PROJECT_DIR=/root/projects
SKIP_TESTS=true
SCRIPT_VERSION=0.1
SCRIPT_LOG=~/.$(basename $0).log

# Redirect all out put to the SCRIPT_LOG
exec 3>&1 4>&2 >$SCRIPT_LOG 2>&1

echo "#################################################################################"
echo "##### BUILD SCRIPT VERSION $SCRIPT_VERSION WAS EXECUTED AT $(date)" >
echo "#################################################################################"

echo "STARTING"

echo  - ADDING A MAVEN SETTINGS FILE 

mkdir -p ~/.m2
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
        <activeProfile>jboss-enterprise-maven-repository-earlyaccess</activeProfile>
    </activeProfiles>
</settings>
EOF1


echo - CREATING A TEMPORARY POM FILE TO PRE-POPULATE PLUGINS
cat > temp-pom.xml <<-EOF2
  <project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>temp</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>pom</packaging>
    
    <build>
      <plugins>
        <plugin>
          <artifactId>maven-clean-plugin</artifactId>
          <version>3.0.0</version>
        </plugin>
        <plugin>
          <artifactId>maven-assembly-plugin</artifactId>
          <version>3.1.0</version>
        </plugin>
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.7.0</version>
        </plugin>
        <plugin>
          <artifactId>maven-enforcer-plugin</artifactId>
          <version>3.0.0-M1</version>
        </plugin>
        <plugin>
          <groupId>org.codehaus.mojo</groupId>
          <artifactId>exec-maven-plugin</artifactId>
        </plugin>
        <plugin>
          <artifactId>maven-failsafe-plugin</artifactId>
          <version>2.20.1</version>
        </plugin>
        <plugin>
          <artifactId>maven-install-plugin</artifactId>
          <version>2.5.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-jar-plugin</artifactId>
          <version>3.0.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-resources-plugin</artifactId>
          <version>3.0.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-surefire-plugin</artifactId>
          <version>2.20.1</version>
        </plugin>        
        <plugin>
          <groupId>org.codehaus.mojo</groupId>
          <artifactId>buildnumber-maven-plugin</artifactId>
          <version>1.4</version>
        </plugin>      
      </plugins>
    </build> 
  </project>
EOF2



echo - BUILDING THE TEMPORARY POM
mvn -q -f temp-pom.xml dependency:go-offline \
    dependency:resolve-plugins \
    dependency:resolve \
    assembly:help \
    compiler:help \
    enforcer:help \
    exec:help \
    failsafe:help \
    install:help \
    jar:help \
    resources:help \
    surefire:help

echo - DELETE THE TEMPORARY POM
rm -rf src dummy-pom.xml

echo - CLONING REPOSITORIES

if [ -d $PROJECT_DIR ]; then
    rm -rf $PROJECT_DIR
fi

mkdir -p $PROJECT_DIR
pushd $PROJECT_DIR > /dev/null
for repo in "${SOURCE_REPOS[@]}"
do
    echo -- CLONING REPO $repo
    git clone --quiet $repo 
done

echo - ITERATING OVER PROJECT AND BUILDING THEM
for pom in $(find . -name pom.xml)
    do
        project=$(dirname "$pom")
        pushd $project > /dev/null
        echo -- BUILDING PROJECT $project
        mvn -q dependency:resolve-plugins dependency:resolve dependency:go-offline clean package install -Dmaven.test.skip=$SKIP_TESTS
        for profile in $(cat pom.xml | grep -A 1 "<profile>" | grep "<id>" | sed 's/.*<id>\(.*\)<\/id>.*/\1/')
        do
            mvn -P$profile dependency:resolve-plugins dependency:resolve dependency:go-offline clean package install -DskipTests
        done
        mvn -q clean
        popd > /dev/null
    done
popd > /dev/null

echo - DONE

# Restore redirects
exec 1>&3 2>&4

