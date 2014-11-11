#!/bin/bash
#===============================================================================
#
#          FILE:  vlan_convert.sh
# 
#         USAGE:  ./vlan_convert.sh 
# 
#   DESCRIPTION:  converts from sles9 vlan configs to rhel4's format
#                 and takes out NETWORK and BROADCAST settings as they are 
#                 superfluous. Creates a backup of the old file.
#       OPTIONS:  takes one option, the filename of a sles9 vlan config file
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  05/20/2008 12:49:29 PM CDT
#      REVISION:  ---
#===============================================================================

if [ $# -ne "1" ] ; then
    echo "Usage: $0 <filename>"
    exit 1
fi

sed -i.sles9 -e "s:STARTMODE='onboot':ONBOOT=yes:g" \
        -e "s:ETHERDEVICE:PHYSDEV:g" \
        -e '/BROADCAST/d' -e '/NETWORK/d' $1

cat >> $1 <<EOF
VLAN=YES
VLAN_NAME_TYPE=VLAN_PLUS_VID_NO_PAD
EOF
