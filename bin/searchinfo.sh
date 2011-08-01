#!/bin/bash
#===============================================================================
#
#          FILE:  searchinfo.sh
# 
#         USAGE:  ./searchinfo.sh 
# 
#   DESCRIPTION:  Extracts and analyzes search engine traffic indicatied in the
#   referrer field of a Commong Log Format access log.
# 
#       OPTIONS:  <logfile> <domain>
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  09/01/07 14:37:06 CDT
#      REVISION:  ---
#===============================================================================

host="$2"; 	maxmatches=20;	count=0
temp="/tmp/$(basename $0).$$"

trap "/bin/rm -f $temp" 0

if [ ! $# -eq 2 ] ; then
	echo "Usage; $(basename $0) <logfile> <host>" >&2
	exit 1
fi

if [ ! -r "$1" ]; then
	echo "Error: can't open file $1 for analysis." >&2
	exit 1
fi
for URL in $(awk '{ if (length($11) > 4 ) { print $11} }' "$1" | \
		grep -vE "(/www.$host|/$host)" | grep '?')
do
	searchengine="$(echo $URL | cut -d/ -f3 | rev | cut -d. -f1-2 | rev)" 
	args="$(echo $URL | cut -d\? -f2 | tr '&' '\n' | \
		grep -E '(^q=|^sid=|^p=|query=|item=|ask=|name=|topic=)' | \
		sed -e 's/+/ /g' -e 's/%20/ /g' -e 's/"//g' | cut -d= -f2)"
		
	if [ ! -z "$args" ] ; then
		echo "${searchengine}:	$args" >> $temp
	else
		# No well known match, show entire GET string instead 
		echo "${searchengine}		$(echo $URL | cut -d\? -f2)" >>$temp
	fi
	count="$(( $count +1 ))"
done

echo "Search engine referrer info extracted from ${1}:"

sort $temp | uniq -c | sort -rn | head -$maxmatches | sed 's/^/ /g'

echo ""
echo Scanned $count entries in log file out of $(wc -l < "$1") total.
exit 0
