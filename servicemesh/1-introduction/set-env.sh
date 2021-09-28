#!/bin/bash

# Wait for katacoda to copy our stuff?
while [ ! -f install-ossm.bash ]
do
	sleep 5
done

bash install-ossm.bash
