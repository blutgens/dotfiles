#!/bin/bash
#===============================================================================
#
#          FILE:  do_rhel.sh
# 
#         USAGE:  ./do_rhel.sh 
# 
#   DESCRIPTION:  Loops through list of RHEL servers and does stuff
# 
#       OPTIONS:  -r (rhel list) -s (sles list) -f <filename>
#  REQUIREMENTS:  needs a list of servers (duh)
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  01/22/2008 10:39:18 AM CST
#      REVISION:  0.1
#===============================================================================
RHEL_LIST=~/.my_rhel_servers
SLES_LIST=~/.my_sles_servers


usage() {
        echo <<USAGE
You must specify either [-r|-s] 'rhel or sles' and <filename> of
script to execute on the remote hosts
e.g. ./list_do.sh -r /tmp/run_this.sh
USAGE
        exit 1
}

if [ $# -ne "2" ] ; then # we want exactly 2 command line args
    usage
fi

while getopts "rsf" flag
do
    
    case ${flag} in
        r )
            echo  "Using RHEL list!"
            CUR_LIST=${RHEL_LIST}
        ;;
        s )
            echo  "Using SLES list!"
            CUR_LIST=${SLES_LIST}
        ;;
        * )
            echo "Got unknown option.. taking a shit!"
            exit 1
        ;;
    esac
done

# makes our last (second) option move over 1 so we can use $1
# to refer to the script we want to copy to the remote host and run
shift $(($OPTIND - 1))
RUN_REMOTELY=$1

for server in `cat $CUR_LIST` ; do
    echo "------------$server -- $RUN_REMOTELY --"
    scp $RUN_REMOTELY $server:/tmp 2>&1 >>list_do.log
    ssh $server -x /tmp/$RUN_REMOTELY 2>&1 >>list_do.log
done
