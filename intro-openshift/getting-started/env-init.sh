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
ssh root@host01 "docker pull centos/python-35-centos7:latest"
ssh root@host01 "docker pull openshiftroadshow/parksmap-katacoda:1.0.0"
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
