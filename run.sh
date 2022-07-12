#!/bin/bash

gradle clean &&
gradle buildNeeded &&

docker compose down &&
docker compose rm &&
docker compose build --no-cache &&
docker compose up

