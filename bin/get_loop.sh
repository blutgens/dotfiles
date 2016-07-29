#!/bin/bash


if [ $2 ] ; then 
    DELAY=${2}
else
    DELAY=5
fi

while : ; do
    echo -n "$(date) : "
    GET $1
    sleep $DELAY
done
