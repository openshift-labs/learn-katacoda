git clone https://github.com/fatherlinux/intro-katacoda.git
ln -s ~/intro-katacoda/intro-openshift/container-internals-lab-3/assets ~/
cp ~/assets/exercise-01/mega-proc.sh /usr/bin/mega-proc.sh
cp ~/assets/exercise-01/atomic-openshift-master.service /etc/systemd/system/atomic-openshift-master.service
cp ~/assets/exercise-01/atomic-openshift-node.service /etc/systemd/system/atomic-openshift-node.service
systemctl disable --now origin.service
systemctl enable --now atomic-openshift-master.service; systemctl enable --now atomic-openshift-node.service
~/.launch.sh
