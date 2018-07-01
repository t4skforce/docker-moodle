#!/usr/bin/env bash
#docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")
rm -r $(pwd)/data
docker kill moodle
docker rm moodle
docker rmi moodle:latest
docker build -t moodle:latest .
mkdir -p $(pwd)/data
docker run --name moodle -d -p 80:80 -p 443:443 -p 8983:8983 -v $(pwd)/data:/mnt/data:rw moodle:latest
docker logs -f moodle
