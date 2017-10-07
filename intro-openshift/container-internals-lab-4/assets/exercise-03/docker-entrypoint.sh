#!/bin/bash
set -e
let "number = $RANDOM % 10 +1"
echo $number > /var/www/html/goodbad.txt
exec "$@"
