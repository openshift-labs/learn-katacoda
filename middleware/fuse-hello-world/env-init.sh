#ssh root@host01 "docker pull registry.access.redhat.com/jboss-fuse-6/fis-java-openshift:latest"
#ssh root@host01 'until $(oc status &> /dev/null); do sleep 1; done && sleep 5 && (oc login -u system:admin >> /opt/logs && oc project openshift >> /opt/logs && oc create -f https://raw.githubusercontent.com/raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json >> /opt/logs)'
#ssh root@host01 "docker pull registry.access.redhat.com/jboss-fuse-7-tech-preview/fuse-java-openshift:latest"
#ssh root@host01 "docker pull registry.access.redhat.com/fuse7/fuse-java-openshift:latest"
ssh root@host01 "for i in {1..200}; do oc project openshift && break || sleep 2; done"
ssh root@host01 "oc create -f https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json"
#ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
