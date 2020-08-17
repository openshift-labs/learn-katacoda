#!/bin/bash

git clone https://github.com/redhat-et/glowing-quantum.git glowing-quantum &> /dev/null
cd glowing-quantum/ &> /dev/null

echo "Git clone complete and OpenShift Ready"
export PS1="$ "
stty echo
