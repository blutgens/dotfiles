#!/bin/bash
#===============================================================================
#
#          FILE:  mqm_install.sh
# 
#         USAGE:  ./mqm_install.sh 
# 
#   DESCRIPTION:  Installs MQM
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  05/20/2008 08:33:15 AM CDT
#      REVISION:  ---
#===============================================================================

install -d -o mqm -g mqm -m 775 /opt/{cmt,mqm}
install -d -o mqm -g mqm -m 775 /var/opt/cmt/env/QMGR_NAME
install -d -o mqm -g mqm -m 775 /{opt,var}/mqm

cat > /etc/profile.d/3m-mqm-environment.sh <<EOF
MQSERVER=E1MLINUX.CHANNEL/tcp/sysr.mmm.com
CMTROOT=/var/opt/cmt/env
CMTENV=UQTE
PATH=${PATH}:/opt/cmt/prod/bin
export MQSERVER CMTROOT CMTENV PATH
EOF

cat > /etc/profile.d/3m-mqm-environment.csh <<EOF
setenv MQSERVER "E1MLINUX.CHANNEL/tcp/sysr.mmm.com"
setenv CMTROOT /var/opt/cmt/env
setenv CMTENV "UQTE"
setenv PATH "${PATH}:/opt/cmt/prod/bin"
EOF
