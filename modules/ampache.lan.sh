#!/bin/bash

# Configuration variables
AMPACHE_DOMAIN="$(basename -- "$0" .sh)"

# Prepare the ampache data folders
echo ">> Creating /srv/data/$AMPACHE_DOMAIN folders..."
mkdir -p "/srv/http/$AMPACHE_DOMAIN/config" &>/dev/null
mkdir -p "/srv/dbs/$AMPACHE_DOMAIN" &>/dev/null

# Install ampache
echo ">> Running ampache..."
docker run \
    -d \
    --name="$AMPACHE_DOMAIN" \
    --restart=always \
    -e "VIRTUAL_HOST=$AMPACHE_DOMAIN" \
    -v "/PATH/TO/MUSIC/ON/THE/HOST:/media:ro" \
    -v "/srv/dbs/$AMPACHE_DOMAIN:/var/lib/mysql" \
    -v "/srv/http/$AMPACHE_DOMAIN/config:/var/www/html/config" \
    ampache/ampache &>/dev/null

# Wait until the docker is up and running
echo -n ">> Waiting for ampache to start..."
while [ ! $(docker top $AMPACHE_DOMAIN &>/dev/null && echo $?) ]
do
    echo -n "."
    sleep 0.5
done
echo "started!"

# Print friendly done message
echo "-----------------------------------------------------"
echo "All right! Everything seems to be installed correctly. Have a nice day!"
echo ">> URL: http://${AMPACHE_DOMAIN}/"
echo "-----------------------------------------------------"