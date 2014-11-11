#!/bin/bash
sudo yum -y install nagios-nrpe
sudo cp ~blutgens/opsview_files/nrpe.cfg /etc/nagios/
sudo cp ~blutgens/opsview_files/check_memory /usr/lib/nagios/plugins/
sudo service nrpe start
sudo chkconfig nrpe on

