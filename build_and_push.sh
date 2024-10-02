#!/bin/bash

# build the container locally and push to dockerhub
docker build -t fedora-dev-container --no-cache .
docker tag fedora-dev-container:latest tino376dev/fedora-dev-container:latest
docker push tino376dev/fedora-dev-container:latest
