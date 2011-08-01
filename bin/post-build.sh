#!/bin/bash
#===============================================================================
#
#          FILE:  post-build.sh
# 
#         USAGE:  ./post-build.sh 
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
#       CREATED:  03/12/2008 01:09:27 PM CDT
#      REVISION:  ---
#===============================================================================

VMWARETOOLS="VMwareTools-3.5.0-64607.i386.rpm"

IS_VM=$(dmesg | grep -iq vmware)
VMTOOLS_INSTALLED=$(rpm -q VMwareTools)

if [ -z $IS_VM -a -n $SKIP_TOOLS ] ; then
    echo  -n "Looks like this is a virtual machine, install vmware tools? [Y|n]"
    read answer
    case "$answer" in 
        n|N) 
            echo "Skipping? WTF? What are you too cool for VMWare Tools?"
        ;;
        y|Y|*) 
        rpm -ivh http://rhbuild.mmm.com/custom/$VMWARETOOLS
        vmware-tools-config.pl -d
        if [ $? -eq "1" ] ; then
            echo "Bah! You're probably trying to run this from an ssh session"
            echo "You'll have to do it the old fashioned way =("
        fi
        ;;
    esac
fi
### VANTAGE
if [ $(arch) == "i686" ] ; then
    rpm -ivh http://prodlm02/linux/software_addons/rh/4/vantage/avagt-9.8.0-1.noarch.rpm
elif [$(arch) == "x86_64" ] ; then
    print "Not installing vantage... looks like we're 64bit"
fi

#for i in ${INTERFACES} ; do
 #   /sbin/ifconfig eth$i | grep "inet addr" | awk '{print $2}' | sed -e 's@addr:@@'
#done




