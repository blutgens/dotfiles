#!/bin/bash
NUMBER=$(sudo lsof -u $1 | wc -l)
while : ; do
    TIME=$(date)
    echo "${TIME} $(hostname -s) - number of open files: ${NUMBER}"
    sleep 600
done

