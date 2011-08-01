#!/bin/bash
if [ $(/sbin/chkconfig snmpd --list | grep on) ] ; then
    sudo cp ~blutgens/opsview_files/snmpd.conf /etc/snmp/
    sudo service snmpd restart
else
    echo "no snmpd here"
fi
sudo cp ~blutgens/opsview_files/nrpe_newdev.cfg /etc/nagios/nrpe.cfg
sudo service nrpe restart
