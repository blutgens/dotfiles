#!/bin/sh
if [ $# -eq "0" ] ; then
	echo "Usage: $0 <filename>"
	exit 1
fi



for line in $(cat $1) ; do
	vlanid=$(echo $line | cut -d, -f1)
	physdev=$(echo $line | cut -d, -f2)
	ipaddr=$(echo $line | cut -d, -f3)
	submask=$(echo $line | cut -d, -f4)
if [ -f ifcfg-vlan$vlanid ] ; then
	echo "not recreating ifcfg-vlan$vlanid"
else
	cat > ifcfg-vlan$vlanid <<EOF
VLAN=yes
VLAN_NAME_TYPE=VLAN_PLUS_VID_NO_PAD
DEVICE=vlan$vlanid
PHYSDEV=eth$physdev
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=$ipaddr
NETMASK=$submask
EOF
	echo "Created ifcfg-$vlanid for eth$physdev $ipaddr	$submask"
fi
done
