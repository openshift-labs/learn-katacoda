oc login -u developer -p developer
oc new-project myproject
oc tag --source=docker tmckay/my-minimal-justnb:3.6 my-minimal-justnb:3.6 -n myproject
oc create -f /root/nbtemp.yaml -n myproject
oc new-app --template=notebook-deployer -p NOTEBOOK_PASSWORD=developer -n myproject
