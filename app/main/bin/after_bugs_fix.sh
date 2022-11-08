#!/usr/bin/env bash

echo -en "- Fixing Rabbit...\n"
docker exec rabbitmq sh -c "rabbitmqctl add_vhost '/ru/'"
docker exec rabbitmq sh -c 'rabbitmqctl set_permissions -p /ru/ guest ".*" ".*" ".*"'

docker exec rabbitmq sh -c "rabbitmqctl add_vhost '/pps/'"
docker exec rabbitmq sh -c 'rabbitmqctl set_permissions -p /pps/ guest ".*" ".*" ".*"'
