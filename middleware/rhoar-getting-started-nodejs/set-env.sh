echo "Installing Node.js and NPM..."
for i in {1..200}; do npm help >& /dev/null && break || (echo -n . ; sleep 2); done
cd ~/projects/rhoar-getting-started/nodejs
clear