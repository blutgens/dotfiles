#!/bin/bash
#===============================================================================
#
#          FILE:  weberrors.sh
# 
#         USAGE:  ./weberrors.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  09/02/07 11:26:56 CDT
#      REVISION:  ---
#===============================================================================
temp="/tmp/$(basename $0).$$"
htdocs="/var/www/html/"
myhome="/home/blutgens"
cgibin="/var/www/cgi-bin"

sedstr="s:^:  :g;s|$htdocs|[htdocs] |;s|$myhome|[homedir] |;s|$cgibin|[cgii-bin] |"

screen="(File does not exist|Invalid error redirect|premature EOF|Premature end of script|script not found)"
length=5

checkfor()
{
	grep "${2}:" "$1" | awk '{print $NF}' |\
		sort | uniq -c |sort -rn | head -$length | sed "$sedstr" > $temp

	if [ $(wc -l < $temp) -gt 0 ]; then
		echo ""
		echo "$2 errors:"
		cat $temp
	fi
}

trap "/bin/rm -f $temp" 0

if [ "$1" = "-1" ] ; then
	length=$2; shift 2
fi

if [ $# -ne 1 -o ! -r "$1" ]; then
	echo "Usage: $(basename $0) [-l len] error_log" >&2
	exit 1
fi

echo Input file $1 has $(wc -l < "$1") entries.

start="$(grep -E '\[.*:.*:.*\]' "$1"|head -1|awk '{print $1" "$2" "$3" "$4" "$5}')"
end="$(grep -E '\[.*:.*:.*\]' "$1"|tail -1|awk '{print $1" "$2" "$3" "$4" "$5}')"

echo -n "Entries from $start to $end"
echo ""

# Check for common errors
checkfor "$1" "File does not exist"
#checkfor "$1" "Invalud error redirection directive"
#checkfor "$1" "premature EOF"
#checkfor "$1" "script not found or unable to stat"
#checkfor "$1" "Premature end of script headers"

#grep -vE "$screen" "$1" | grep "\[error\]" | grep "\[client " | \
#	sed 's:\[error\]:\`:g' | cut -d\`  -f2 | cut -d\ -f4 | \
#	sort | uniq -c | sort -rn | sed 's/^/ /' | head -$length > $temp


if [ $(wc -l < $temp) -gt 0 ] ; then
	echo ""
	echo "Additional error messages in logfile: "
	cat $temp
fi

echo ""
echo "And non-error messsages occuring in the log file:"

grep -vE "$screen" "$1" | grep -v "\[error\]" | \
	sort | uniq -c | sort -rn | \
	sed 's/^/  /' | head -$length

exit 0
