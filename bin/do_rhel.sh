#!/bin/bash
#===============================================================================
#
#          FILE:  do_rhel.sh
# 
#         USAGE:  ./do_rhel.sh 
# 
#   DESCRIPTION:  Loops through list of RHEL servers and does stuff
# 
#       OPTIONS:  pass -r to use the rhel servers list, use -s for sles
#                  also give it a shell script/command to run
#  REQUIREMENTS:  needs a list of servers (duh)
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  01/22/2008 10:39:18 AM CST
#      REVISION:  0.1
#===============================================================================
RHEL_LIST="~/.my_rhel_servers"
SLES_LIST="~/.my_sles_servers"


