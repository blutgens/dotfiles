#!/bin/bash
DISPLAY=:0
SIZE=${1}
if [ -z $SIZE ] ; then
    echo "This script requires an option, please run it like so"
    echo "$0 [num_of_pixels]"
    echo "Where num_of_pixels is a size, try 16 or 22"
elif [ $SIZE -ge 12 ]; then
        dconf  write /org/compiz/profiles/unity/plugins/unityshell/icon-size "$1"
    echo "Size is set to $SIZE"
else
    echo "Integers lower than 12 are ignored by unity."
fi
