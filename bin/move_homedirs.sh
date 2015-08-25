#!/bin/bash

NPSAS="certs ducs iqdr stds qcdata hrapps ekos ffds qdr hr ql macs mkroll mass
menu ncn gamma s10 label library pmcs planning plant procdata tnt bkftp"

for i in $NPSAS ; do 
    usermod -d /app/$i -m $i
done
