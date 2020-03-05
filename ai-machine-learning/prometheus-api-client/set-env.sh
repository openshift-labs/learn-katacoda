while [ ! -f ~/setup.sh ]; do sleep 1; done # wait for the setup.sh file to exist
chmod +x ~/setup.sh
clear
~/setup.sh
