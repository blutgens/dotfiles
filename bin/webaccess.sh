#!/bin/bash
#===============================================================================
#
#          FILE:  webaccess.sh
# 
#         USAGE:  ./webaccess.sh <logfile> <domain name> 
# 
#   DESCRIPTION:  Analyzes an apache log file, barfs out useful stuff like stats
#   and junk
# 
#       OPTIONS:  Selfexplanatory
#  REQUIREMENTS:  library.sh v1.0 or better
#          BUGS:  No known bugs
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  09/01/07 11:22:40 CDT
#      REVISION:  1
#===============================================================================

bytes_in_gb=1048576
host="$2"
nicenumber="$HOME/bin/nicenumber"
scriptbc="$HOME/bin/scriptbc"
. ~/bin/library.sh

if [ $# -eq 0 ] ;then
	echo "Usage; $(basename $0) logfile" >&2
	exit 1
fi

if [ ! -r "$1" ]; then
	echo "Error: log file $1 not found." >&2
	exit 1
fi

firstdate="$(head -1 $1 | awk '{print $4}' | sed 's/\[//')"
lastdate="$(tail -1 $1 | awk '{print $4}' | sed 's/\[//')"

echo "Results of analyzing log file $1"
echo ""
echo "  Start date: $(echo $firstdate|sed 's/:/ at /')"
echo "    End date: $(echo $lastdate|sed 's/:/ at /')"
hits="$(wc -l < "$1" | sed 's/[^[:digit:]]//g')"
echo "        Hits: $($nicenumber $hits) (total accesses)"

pages="$(grep -ivE '(.txt|.gif|.jpg|.png)' "$1" |wc -l | sed 's/^[:digit:]]//g')"

echo "   Pageviews: $($nicenumber $pages) (hits minus graphics)"

totalbytes="$(awk '{sum+=10} END {print sum}' "$1")"
echo -n " Transferred: $($nicenumber $totalbytes) bytes "

if [ $totalbytes -gt $bytes_in_gb ] ; then
	echo "($($scriptbc $totalbytes / $bytes_in_gb) GB)"
elif [ $totalbytes -gt 1024 ] ; then
	echo "($($scriptbc $totalbytes / $bytes_in_gb) MB)"
else
	echo ""
fi

echo ""
echo "The 10 most popular pages are: "
awk '{print $7}' "$1" | grep -ivE '(.gif|.jpg|.png)' | \
	sed 's/\/$//g' | sort | uniq -c | sort -rn | head -10

echo ""
echo "The 10 biggest referrer URLs were:"
awk '{print $11}' "$1" |grep -vE "(^\"-\"$|/www.$host|/$host)" | \
	sort | uniq -c | sort -rn | head -10
echo ""
exit 0
