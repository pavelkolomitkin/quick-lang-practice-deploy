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
    git clone https://github.com/pavelkolomitkin/quick-lang-practice-backend-nest.git backend_src
fi

cd ./backend_src && git pull origin master && cd ..


# - build a new version of the backend project
echo -en '\n'
echo 'Build backend application code...'
echo -en '\n'
# Build the builder image
docker build -t ql/build-app -f docker/app-build.docker .
# Build the project
docker run --rm -v $(pwd)/backend_src:/app -w /app ql/build-app npm install
docker run --rm -v $(pwd)/backend_src:/app -w /app ql/build-app npm run prestart:prod

# up backend compose in order to
echo -n 'Up backend containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose-backend-build.yaml up -d

# - perform database migrations
echo -en '\n'
echo 'Run database migrations...'
echo -en '\n'
docker exec app-container-build npm run migrate-mongo up

echo -en '\n'
echo -n 'Stop build containers...'
echo -en '\n'
docker-compose -f ./docker/docker-compose-backend-build.yaml down

echo -en '\n'
echo -n 'Build a production image...'
echo -en '\n'
docker image rm ql/app
docker build -t ql/app -f docker/app.docker .

