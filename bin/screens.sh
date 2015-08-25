#!/bin/sh 
SCREENS="243 277 camel tsm prodlm psdb2 tools wms bk vcc ppfdd"
for i in ${SCREENS} ; do
    THIS="screen -S $i -c .screenrc_$i"
    gnome-terminal -t $i -x ${THIS} &
done
