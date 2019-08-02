#!/usr/bin/env bash

echo -en '\n'
echo 'Build frontend...'
echo -en '\n'

echo -en '\n'
echo 'Fetch the code source...'
echo -en '\n'
if [[ ! -d ./frontend_src/ ]]
then
    git clone https://github.com/pavelkolomitkin/quick-lang-practice-frontend.git frontend_src
fi
cd ./frontend_src && git pull origin master && cd ..

echo -en '\n'
echo 'Build...'
echo -en '\n'
cd ./frontend_src/build/prod
/bin/bash build.sh
cd ../../../