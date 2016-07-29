#!/bin/bash
#===============================================================================
#
#          FILE:  migration_prep.sh
# 
#         USAGE:  ./migration_prep.sh 
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
#       CREATED:  05/22/2008 08:18:24 AM CDT
#      REVISION:  ---
#===============================================================================

mkdir /tmp/$(hostname -s)_prep
cd  /tmp/$(hostname -s)_prep

cp /etc/{passwd,shadow,group,sudoers,sysctl.conf,fstab} .
cp -r /etc/ssh .
rsync -avz /{root,home} .

