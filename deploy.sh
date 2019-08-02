#!/usr/bin/env bash

# Stop previous the container compose
echo -en '\n'
echo -n 'Stop previous containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose.yaml down

# Build the project
/bin/bash ./build-backend.sh
/bin/bash ./build-frontend.sh

# up the compose of containers
echo -en '\n'
echo -n 'Up production containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose.yaml up -d

echo -en '\n'
echo -n 'Config mail server...'
echo -en '\n'
/bin/bash ./config-mail-server.sh