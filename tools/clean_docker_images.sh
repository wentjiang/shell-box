#!/bin/bash

docker_image_ids=$(docker images |awk -F '[ ]{2,}' '{print $1, $2, $3}' |grep '<none>' |awk '{print $3}')

for line in $docker_image_ids
do
  echo "docker rmi $line"
  docker rmi "$line"
done