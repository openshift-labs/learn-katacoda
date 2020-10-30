oc adm policy add-scc-to-user anyuid system:serviceaccount:camel-kafka:default
oc new-app quay.io/redhatintegration/sftp --name ftpserver --as-deployment-config
oc create secret generic ftp-users --from-file=sftp/users.conf
oc create secret generic sftp-ssh-key --from-file=sftp/demo_rsa

oc set volume dc/ftpserver --add --mount-path=/etc/sftp --secret-name=ftp-users --read-only=true
oc set volume dc/ftpserver --add --mount-path=/home/foo/.ssh/keys --secret-name=sftp-ssh-key --read-only=true


