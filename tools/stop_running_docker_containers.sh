#!/bin/bash

docker_container_ids=$(docker ps | awk -F '[ ]{2,}' '{print $1,$5}' |grep -v Up |tail -n +2 | awk '{print $1}')

for line in $docker_container_ids
do
  echo "docker stop ${line}"
  docker stop "${line}"
done
