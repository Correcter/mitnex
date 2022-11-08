#!/bin/bash

# exporting env variables from dotenv file
set -o allexport
source .env
set +o allexport

curl -u "$NEXUS_USERNAME":"$NEXUS_PASSWORD" https://bin.8adm.com/repository/mostbet-front/mostbet-front-local.latest.tar.gz -o ./spa.tar.gz
docker cp ./spa.tar.gz nginx:/usr/share/nginx/
docker exec nginx sh -c 'chown root:root /usr/share/nginx/spa.tar.gz'
docker exec nginx sh -c 'rm -rf /usr/share/nginx/spa/*'
docker exec nginx sh -c 'mkdir -p /usr/share/nginx/spa/releases/tmp'
docker exec nginx sh -c 'tar -xf /usr/share/nginx/spa.tar.gz -C /usr/share/nginx/spa/releases/tmp'
docker exec nginx sh -c 'cp /usr/share/nginx/spa/releases/tmp/.version /usr/share/nginx/spa/releases/'
rm ./spa.tar.gz
docker exec nginx sh -c 'mv /usr/share/nginx/spa/releases/tmp /usr/share/nginx/spa/releases/`cat /usr/share/nginx/spa/releases/.version`'
docker exec nginx sh -c 'ln -sfn /usr/share/nginx/spa/releases/`cat /usr/share/nginx/spa/releases/.version` /usr/share/nginx/spa/current'

curl -u "$NEXUS_USERNAME":"$NEXUS_PASSWORD" https://bin.8adm.com/repository/mostbet-front-ru/mostbet-front-local.latest.tar.gz -o ./spa-ru.tar.gz
docker cp ./spa-ru.tar.gz nginx:/usr/share/nginx/
docker exec nginx sh -c 'chown root:root /usr/share/nginx/spa-ru.tar.gz'
docker exec nginx sh -c 'rm -rf /usr/share/nginx/spa-ru/*'
docker exec nginx sh -c 'mkdir -p /usr/share/nginx/spa-ru/releases/tmp'
docker exec nginx sh -c 'tar -xf /usr/share/nginx/spa-ru.tar.gz -C /usr/share/nginx/spa-ru/releases/tmp'
docker exec nginx sh -c 'cp /usr/share/nginx/spa-ru/releases/tmp/.version /usr/share/nginx/spa-ru/releases/'
rm ./spa-ru.tar.gz
docker exec nginx sh -c 'mv /usr/share/nginx/spa-ru/releases/tmp /usr/share/nginx/spa-ru/releases/`cat /usr/share/nginx/spa-ru/releases/.version`'
docker exec nginx sh -c 'ln -sfn /usr/share/nginx/spa-ru/releases/`cat /usr/share/nginx/spa-ru/releases/.version` /usr/share/nginx/spa-ru/current'
