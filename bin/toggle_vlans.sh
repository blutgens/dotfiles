#!/bin/bash
#===============================================================================
#
#          FILE:  toggle_vlans.sh
# 
#         USAGE:  ./toggle_vlans.sh 
# 
#   DESCRIPTION:  start, stop, or restart all the vlans that are configured
# 
#       OPTIONS:  [ start | stop | restart | status ]
#  REQUIREMENTS:  rhel or sles, and vlans
#          BUGS:  What are these bugs of which you speak
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  04/17/2008 02:57:07 PM CDT
#      REVISION:  ---
#===============================================================================
if [ -e /etc/SuSE-release ] ; then
    NETCONF_DIR="/etc/sysconfig/network"
elif [ -e /etc/redhat-release ] ; then
    NETCONF_DIR="/etc/sysconfig/network-scripts"
fi

if [ $# -ne "1" ] ; then
    echo $"Usage: $0 {start|stop|restart|status}"
fi

do_vlans() {
    cd $NETCONF_DIR
    CMD=$1
    if [ ${CMD} == "status" ] ; then
        for i in $(ls ifcfg-vlan*) ; do
            THIS_VLAN=$(echo ${i}| sed -e "s:ifcfg-::")
            ifconfig ${THIS_VLAN} 2>&1 | grep -q "not found"
            if [ $? -eq "0" ] ; then
                echo "${THIS_VLAN} is down"
            else
                echo "${THIS_VLAN} is up"
            fi
        done
    else
        for i in $(ls ifcfg-vlan*) ; do
            THIS_VLAN=$(echo ${i}| sed -e "s:ifcfg-::")
            $CMD ${THIS_VLAN}
        done
    fi
    cd ${OLDPWD}
}

case $1 in
    start)
        do_vlans ifup
    ;;
    stop)
        do_vlans ifdown
    ;;
    restart)
        do_vlans ifdown
        do_vlans ifup
    ;;
    status)
        do_vlans status
    ;;
    *)
esac
