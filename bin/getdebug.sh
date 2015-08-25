#!/bin/sh
set -x
hostname >> /tmp/$(hostname).out
uname -a >> /tmp/$(hostname).out 
cd /usr/openv/volmgr/bin
./vmoprcmd >> /tmp/$(hostname).out 
./vmdareq -display >> /tmp/$(hostname).out 
./scan -changer >> /tmp/$(hostname).out 
./tpconfig -dl >> /tmp/$(hostname).out 
./tpautoconf -t >> /tmp/$(hostname).out 
cat /var/log/messages >> /tmp/$(hostname).out

