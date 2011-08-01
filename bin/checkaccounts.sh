#!/bin/bash
# Shell script for search for no password entries and lock all accounts
# -------------------------------------------------------------------------
# Copyright (c) 2005 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Set your email 
ADMINEMAIL="blutgens@mmm.com"

### Do not change anything below ###
#LOG File
LOG="/root/nopassword.lock.log"
STATUS=0
TMPFILE="/tmp/null.mail.$$"

echo "-------------------------------------------------------" >>$LOG
echo "Host: $(hostname),  Run date: $(date)" >> $LOG
echo "-------------------------------------------------------" >>$LOG

# get all user names
USERS="$(cut -d: -f 1 /etc/passwd)"

# display message
echo "Searching for null password..."
for u in $USERS
do
  # find out if password is set or not (null password)
   passwd -S $u | grep -Ew "NP" >/dev/null
   if [ $? -eq 0 ]; then # if so 
     echo "$u" >> $LOG 
     passwd -l $u #lock account
     STATUS=1  #update status so that we can send an email
   fi  
done
echo "========================================================" >>$LOG 
if [ $STATUS -eq 1 ]; then
   echo "Please see $LOG file and all account with no password are locked!" >$TMPFILE
   echo "-- $(basename $0) script" >>$TMPFILE
   mail -s "Account with no password found and locked" "$ADMINEMAIL" < $TMPFILE
#   rm -f $TMPFILE
fi

