#!/usr/local/bin/bash
# A wrapper around chown that will let developers chown files in /uc_custom
# This was written to work around a limitation of the Isilon NFS service that prevents users
# from chowning their own files to another user, e.g. AmiOwn. 


if [ $# -ne 2 ] ; then
	echo "Usage $0 <Username> <filename>"
	exit 1
fi

# This bit makes sure they are only running this where we want them to be able to
# May need to expand this by checking against an array.
test "${PWD##/uc_custom/6}" != "${PWD}"
if [ $? -eq 1 ]; then
	echo "You must run this from inside /uc_custom/6 subdirectory."
	exit $?
fi

NEWUSER=${1}

# Running basename on $2 keeps from people chowing stuff outside of cwd.
FILENAME=$(basename ${2})


# bash array of allowed users this script can chown to. 
ALLOWED_USERS=("AmiDev" "AmiQa" "AmiTrn" "AmiExd" "AmiPec"
			   "AmiPecs" "AmiExpec" "AmiI10p" "AmiI10q" "AmiI10t"
			   "AmiI10s" "AmiBp"
			   )


# Checks an array for a value
containsElement(){
	local e
	for e in "${@:2}"; do 
		[[ "$e" == "$1" ]] && return 0;
   	done
	return 1
}


containsElement "${1}" "${ALLOWED_USERS[@]}" 
if [ $? -eq 0 ] ; then
	#sudo chown "${1} "$FILENAME}
	echo "TEST: chown ${1} ${FILENAME}"
else 
	echo "Nope, that username is not in the list."
	echo "Please contact the infrastructure team."
fi

# vim: noai:ts=4:sw=4
