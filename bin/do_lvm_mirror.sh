#!/bin/sh
#===============================================================================
#
#          FILE:  do_lvm_mirror.sh
# 
#         USAGE:  ./do_lvm_mirror.sh 
# 
#   DESCRIPTION:  script to mirror your vg00 logical volumes on HP-UX
# 
#       OPTIONS:  -s "Skip pvcreate"
#                 -d "dry run, don't do anything just print what we would do"
#  REQUIREMENTS:  posix shell
#          BUGS:  meh, i write shitty code. expect some
#         NOTES:  This script assumes you want to mirror your logical volumes
#                 on vg00.
#        AUTHOR:  Ben Lutgens - blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  12/03/2007 09:19:37 AM CST
#      REVISION:  ---
#===============================================================================

# Supply the mirror_target and lvols (vg00) to mirror
mirror_target="c2t2d0"
lvols="lvol1 lvol2 lvol3 lvol4 lvol5 lvol6 lvol7 lvol8 lvol9"


while getopts "ds" opt; do
	case $opt in
		d ) dryrun="1" 				;; # just a dry run, so only echo commands
		s ) skip_pvcreate="1" ;; # pv already belongs to right vg
		* )					 					;;
	esac
done

if [ $(id -u) != "0" ] ; then
	echo "You are not root, this command for grown folks only!"
	echo "You'll shoot your eye out kid! HO HO HO!"
	exit 1
fi

# prep our mirror target pv
if [ "$dryrun" -eq "1"  ] ; then
	echo "pvcreate -B /dev/rdsk/$mirror_target"
fi
if [ "$skip_pvcreate" = "1" ]; then
	echo "Skipping pvcreate as per command line opt"
else 
	pvcreate -B /dev/rdsk/$mirror_target
	if [ "$?" -eq "1" ] ; then
		echo "pvcreate of /dev/rdsk/$mirror_target failed!"
		echo -n "Would you like to force? [N|y] Carefull!!! >"
		read answer
		case $answer in 
			[yY] ) pvcreate -B -f /dev/rdsk/$mirror_target
					 ;;
			*  ) echo "Bailing out!" ; exit 1
					 ;;
		esac
	fi
fi

if [ "$dryrun" = "1" ] ; then
	echo "vgextend vg00 /dev/dsk/$mirror_target"
else 
	vgextend vg00 /dev/dsk/$mirror_target
fi


# make sure last command worked before we continue, can't setup a
# mirror without a target device...
if [ "$?" = "1" ]; then
	echo "Unable to setup mirror target using /dev/rdsk/$mirror_target!"
	exit 1
fi

for i in $lvols ; do
	if [ "$dryrun" = "1" ]; then
		echo "lvextend -m 1 /dev/vg00/$i /dev/dsk/$mirror_target"
	else
		lvextend -m 1 /dev/vg00/$i /dev/dsk/$mirror_target
	fi
done
	
