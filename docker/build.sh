#!/bin/bash

name='ringier-nodejs-app'

docker build . -t "ringier/nodejs-app"

# only run if not already running
[[ $(docker ps -f "name=$name" --format '{{.Names}}') == $name ]] ||
docker run -p 8080:8080 --name "$name" -d "ringier/nodejs-app"