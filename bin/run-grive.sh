#!/bin/bash
if [ -d ~/Grive ] ; then
    cd ~/Grive
    grive -l ~/.grive-sync.log
else 
    echo "There's no ~/Grive directory you moron."
fi
