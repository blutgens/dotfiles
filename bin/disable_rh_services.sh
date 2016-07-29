#!/bin/sh
SERVICES="avahi-daemon avahi-dnsconfd bluetooth conman NetworkManager                     NetworkManagerDispatcher cpuspeed cups dund firstboot gpm                       haldaemon hidd ipmi irda mdmonitor mdmpd messagebus microcode_ctl               multipathd netconsole netplugd nscd ntpd oddjobd pand pcscd rdisc               psacct saslauthd smartd snmpd snmptrapd winbind wpa_supplicant                  yum-updatesd xfs"

for i in ${SERVICES} ; do
    echo -n "Disabling ${i}: "
    sudo chkconfig ${i} off
    if [ $? -eq "0" ] ; then
        echo "O.k."
    else
        echo 'Error!'
    fi
done
