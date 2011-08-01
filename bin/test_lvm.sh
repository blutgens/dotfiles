#!/bin/bash
#===============================================================================
#
#          FILE:  test_lvm.sh
# 
#         USAGE:  ./test_lvm.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  02/14/2008 10:39:34 AM CST
#      REVISION:  ---
#===============================================================================

pvcreate /dev/sdb1
vgcreate /dev/sdb1 vg02
vgdisplay vg02
vgcreate vg02 /dev/sdb1 
vgdisplay vg02
lvcreate -l 5118 -n lvol1 vg02
mke2fs -j /dev/vg02/lvol1
cat >>/etc/fstab <<EOF
/dev/vg02/lvol1     /srv        ext3    defaults 1 2
EOF
mount /srv
