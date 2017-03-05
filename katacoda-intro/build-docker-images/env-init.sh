echo '{' >> route.json
echo '  "metadata": {' >> route.json
echo '    "name": "frontend"' >> route.json
echo '  },' >> route.json
echo '  "apiVersion": "v1",' >> route.json
echo '  "kind": "Route",' >> route.json
echo '  "spec": {' >> route.json
echo '    "to": {' >> route.json
echo '      "name": "frontend"' >> route.json
echo '    }' >> route.json
echo '  }' >> route.json
echo '}' >> route.json
scp route.json root@host01:~/route.json
ssh root@host01 "oc adm registry -n default --config=/openshift.local.config/master/admin.kubeconfig"
ssh root@host01 "docker pull ocelotuproar/alpine-node:5.7.1"
