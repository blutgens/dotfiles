#!/bin/bash

MAX=30
if [ 
for suffix in sgs pgs ; do
    for ((a=1; a <= MAX; a++)) ; do 
        host $1$suffix$a > /dev/null
        [ "$?" -eq "0" ] && echo " valid dns entry: $1sgs$a" 
    done
done
