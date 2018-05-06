~/.launch.sh

oc adm policy add-cluster-role-to-user cluster-admin developer
oc new-project myproject

oc apply -n openshift -f https://gist.githubusercontent.com/kadel/bb5c86158bfc44e335ea99c91fab04e3/raw/my-wildfly-is.yaml
oc apply -n openshift -f https://gist.githubusercontent.com/kadel/ee43d945013931c43cab5d8280847102/raw/my-php-is.yaml

# download images
oc import-image -n openshift wildfly
oc import-image -n openshift php
