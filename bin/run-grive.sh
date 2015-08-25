#!/bin/bash

if [ -f /tmp/$LOGNAME.lck ] ; then 
    echo "grive still running" 
    exit 1
elif [ -d ~/Grive ] ; then
    touch /tmp/$LOGNAME-grive.lck
    cd ~/Grive
    grive -l ~/.grive-sync.log
    rm /tmp/$LOGNAME-grive.lck
else 
    echo "There's no ~/Grive directory you moron."
fi
