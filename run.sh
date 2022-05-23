#!/bin/bash

gradle clean &&
gradle buildNeeded &&

sudo docker-compose down &&
sudo docker-compose rm &&
sudo docker-compose build --no-cache &&
sudo docker-compose up

