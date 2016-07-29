#!/bin/bash
#===============================================================================
#
#          FILE:  disable_cluster.sh
# 
#         USAGE:  ./disable_cluster.sh 
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
#       CREATED:  04/16/2008 01:30:25 PM CDT
#      REVISION:  ---
#===============================================================================

DAEMONS="rgmanager gfs clvmd fenced ccsd"
for i in ${DAEMONS} ; do
    chkconfig $i on
done
