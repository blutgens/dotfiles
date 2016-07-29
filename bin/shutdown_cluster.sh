#!/bin/bash
#===============================================================================
#
#          FILE:  shutdown_cluster.sh
# 
#         USAGE:  ./shutdown_cluster.sh 
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
#       CREATED:  04/16/2008 01:27:25 PM CDT
#      REVISION:  ---
#===============================================================================

clusvcadm -d batpd01
clusvcadm -d batpd02
CLUSTERWARE="rgmanager gfs clvmd fenced"
for i in ${CLUSTERWARE} ; do
    service $i stop
done

cman_tool leave
service ccsd stop


