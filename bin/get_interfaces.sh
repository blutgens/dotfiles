#!/bin/bash
#===============================================================================
#
#          FILE:  get_interfaces.sh
# 
#         USAGE:  ./get_interfaces.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  03/13/2008 09:02:10 AM CDT
#      REVISION:  ---
#===============================================================================
MY_TEMPDIR=`mktemp -d /tmp/iface_finder.XXXX` || exit 1
cd $MY_TEMPDIR


for iface in $(egrep -o "(eth|vlan)[0-9]{1,3}" /proc/net/dev)
do
    echo "DEVICE=${iface}" >> ifcfg-${iface}
    echo "BOOTPROTO=static" >> ifcfg-${iface}
    MACADDRESS=$(/sbin/ifconfig ${iface} | head -1 | awk '{print $5}')
    echo "HWADDR=${MACADDRESS}" >> ifcfg-${iface}
    /sbin/ifconfig ${iface} | grep "inet addr" | awk '{print $2 $4}' |\
    sed -e 's@addr:@IPADDR=@' -e 's@Mask:@\nNETMASK=@' >>  ifcfg-${iface} 
done
if [ $? -eq "0" ]; then
    echo "your shiny new config files are in $MY_TEMPDIR"
    cd $OLDPWD
else 
    echo "Something broke! No soup for you! FUCK OFF!!"
fi
