#!/bin/bash

if [ -f /tmp/$LOGNAME.lck ] ; then 
    echo "grive still running" 
    exit 1
elif [ -d ~/Google\ Drive ] ; then
    touch /tmp/$LOGNAME-grive.lck
    grive -p ~/Google\ Drive  -l ~/.grive-sync.log 2>&1 >/dev/null
    rm /tmp/$LOGNAME-grive.lck
else 
    echo "There's no ~/Google\ Drive directory you moron."
fi
