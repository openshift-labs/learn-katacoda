#!/bin/bash

# Wait for katacoda to copy our stuff?
while [ ! -f 01-prepare/install-serverless.bash ]
do
	sleep 5
done

bash 01-prepare/install-serverless.bash
