#!/bin/bash
#===============================================================================
#
#          FILE:  cm4_do.sh
# 
#         USAGE:  ./cm4_do.sh 
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
#       CREATED:  01/24/2008 09:32:39 AM CST
#      REVISION:  ---
#===============================================================================

hosts="stagewww0 stagewww1 xmpp0 xmpp1 staging0 staging1"

for i in ${hosts} ; do
    ssh root@cm4$i -x $1
done
