#!/bin/bash

while [ ! -f serverless/install-serverless.sh ]
do
	sleep 5
done

bash serverless/install-serverless.sh


