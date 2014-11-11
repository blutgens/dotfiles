#!/usr/bin/sh
date
for i in $(ps -ef | grep qk | grep -v grep | awk '{print $9}' | cut -d "." -f 1)
	do
		session=`ps -ef | grep -w $i | grep -v grep | wc -l`
		if [ $session -ne 1 ] ; then
			echo "$i has multiple logins"
	fi
done

# vim: set sw=4 ts=4 :
