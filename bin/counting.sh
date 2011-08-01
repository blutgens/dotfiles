#!/bin/bash
LIMIT=20
for ((a=1; a <= LIMIT ; a++))
	do echo -n "$a "
 sleep 1
done
#======================================
LIMIT="0"
while [ ${LIMIT} -lt 20 ]
do
	echo -n "$LIMIT "
	LIMIT=`expr $LIMIT + 1`
done
#=====================================
LIMIT="0"
until [ ${LIMIT} -eq 20 ]
do
	echo -n "$LIMIT "
	let "LIMIT+=1"
done
