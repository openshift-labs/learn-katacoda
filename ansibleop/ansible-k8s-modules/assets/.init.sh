echo 'Prepping environment'
while ! [ -x "$(command -v ansible)" ]
do
  echo 'Waiting...' >&2
  sleep 5
done
sleep 5
cd /root/tutorial
ansible-galaxy init example-role --offline >> /dev/null
echo 'Ready to go!'
