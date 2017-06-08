~/.launch.sh
ssh root@host01 "oc project openshift"
ssh root@host01 "oc create -f https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json"
