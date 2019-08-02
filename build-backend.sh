#!/usr/bin/env bash

# Stop previous the container compose
echo -n 'Stop previous build containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose-backend-build.yaml down

# pull backend repository
echo -en '\n'
echo 'Pull the source code...'
echo -en '\n'
if [[ ! -d ./backend_src/ ]]
then
    git clone -b feature/client/prod-mailing https://github.com/pavelkolomitkin/quick-lang-practice-backend-nest.git backend_src
fi
# TODO switch to master branch when it will be completed
#cd ./backend_src && git pull origin master && cd ..
cd ./backend_src && git pull origin feature/client/prod-mailing && cd ..


# up backend compose in order to
echo -n 'Up backend containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose-backend-build.yaml up -d
# - build a new version of the backend project
echo -en '\n'
echo 'Build backend application code...'
echo -en '\n'
docker exec app-container-build npm run prestart:prod

# - perform database migrations
echo -en '\n'
echo 'Run database migrations...'
echo -en '\n'
docker exec mongo-container-prod npm run migrate-mongo up

echo -n 'Stop build containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose-backend-build.yaml down

