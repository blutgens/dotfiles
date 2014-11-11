#!/bin/bash
#===============================================================================
#
#          FILE:  iptables-script.sh
# 
#         USAGE:  ./iptables-script.sh 
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
#       CREATED:  03/10/2008 02:13:47 PM CDT
#      REVISION:  ---
#===============================================================================
i#!/bin/bash
# Firewall for Red hat enterprise linux Virtuozzo VPS
# It is  simple firewall but effective one on Red hat enterprise linux Virtuozzo VPS :)
# ---------------------------------------------------------
# 1) DO NOT FORGEDT TO SETUP CORRECT IPS first
# 2) touch /root/allbadips.txt; echo "192.1678.0.10"> /root/allbadips.txt
# 3) To load/start firewall from this script
# chmod +x virtuozzo-iptables-firewall-script.bash
# ./virtuozzo-iptables-firewall-script.bash
# -----------------------------------------------------
# Laste updated : Aug - 08 - 2005
# -----------------------------------------------------
# Copyright (C) 2004,2005 nixCraft <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# For more info, please visit:
# http://www.cyberciti.biz/nixcraft/vivek/blogger/2004/12/virtuozzo-iptables-firewall.html
#-----------------------------------------------------
# ip = can be setup once - Aug-2005.
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------

# BAD IPS FILE all ip in this file are droped
BADIPS="$(cat /root/allbadips.txt|grep -v -E "^#")"
# setup your IPS here 
myIPS="xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx"

# Setup VPS main IP here
ip="xxx.xxx.xxx.xxx"

# stop RedHAT linux iptables
service  iptables stop

# Setting default filter policy DROP ALL :D
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# allow unlinited traffic on both lo and venet0
iptables -A INPUT  -i venet0 -s 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -o venet0 -d 127.0.0.1 -j ACCEPT

iptables -A INPUT  -i lo -s 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -o lo -d 127.0.0.1 -j ACCEPT

# Block all those IPs
for ip in $BADIPS
do
    iptables -A INPUT -s $ip -j DROP
    iptables -A OUTPUT -d $ip -j DROP
done
# Stop  flood 
iptables -N flood
iptables -A INPUT -p tcp --syn -j flood
iptables -A flood -m limit --limit 1/s --limit-burst 3 -j RETURN
iptables -A flood -j DROP
# Spoofing and bad addresses
# Bad incoming source ip address i.e server IP drop all here
for myip in $myIPS
do
    iptables -A INPUT -s $myip -j DROP
done

# Drop all incoming fragments
iptables -A INPUT -f -j DROP

# Drop all incoming malformed XMAS packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Drop all incoming malformed NULL packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Bad incoming source ip address 0.0.0.0/8
iptables -A INPUT -s 0.0.0.0/8 -j DROP

# Bad incoming source ip address 127.0.0.0/8
iptables -A INPUT -s 127.0.0.0/8 -j DROP

# Bad incoming source ip address 10.0.0.0/8
iptables -A INPUT -s 10.0.0.0/8 -j DROP

# Bad incoming source ip address 172.16.0.0/12
iptables -A INPUT -s 172.16.0.0/12 -j DROP

# Bad incoming source ip address 192.168.0.0/16
iptables -A INPUT -s 192.168.0.0/16 -j DROP

# Bad incoming source ip address 224.0.0.0/3
iptables -A INPUT -s 224.0.0.0/3 -j DROP

#Open Port 80 , no statful fw as VPS don't support it :(
#ip="xxx.xxx.xxx.xxx" # IP of your www service
iptables -A INPUT -p tcp -s 0/0 --sport 1024:65535 -d $ip --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ip --sport 80 -d 0/0 --dport 1024:65535 -j ACCEPT

#Open Port 443
#ip="xxx.xxx.xxx.xxx" # IP of your wwws service
iptables -A INPUT -p tcp -s 0/0 --sport 1024:65535 -d $ip --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ip --sport 443 -d 0/0 --dport 1024:65535 -j ACCEPT

#Open Port 25
#ip="xxx.xxx.xxx.xxx" 
iptables -A INPUT -p tcp -s 0/0 --sport 1024:65535 -d $ip --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ip --sport 25 -d 0/0 --dport 1024:65535 -j ACCEPT

#Open port 22 for all
#ip="xxx.xxx.xxx.xxx"
iptables -A INPUT -p tcp -s 0/0 --sport 513:65535 -d $ip --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ip --sport 22 -d 0/0 --dport 513:65535 -j ACCEPT

# Outgoing DNS
# udp first
NSIP="ns1_IP  ns2_IP" # NS1 NS2 of ISP
#ip="your_main_IP"
for mip in $NSIP
do
  iptables -A OUTPUT -p udp -s $ip --sport 1024:65535 -d $mip --dport 53 -j ACCEPT
  iptables -A INPUT -p udp -s $mip --sport 53 -d $ip --dport 1024:65535 -j ACCEPT
  # tcp next
  iptables -A OUTPUT -p tcp -s $ip --sport 1024:65535 -d $mip --dport 53 -j ACCEPT
  iptables -A INPUT -p tcp -s $mip --sport 53 -d $ip --dport 1024:65535 -j ACCEPT
done

#outgoin ICMP
#ip="your_main_IP"
iptables -A OUTPUT -p icmp -s $ip -d 0/0 -j ACCEPT
iptables -A INPUT -p icmp -s 0/0 -d $ip -j ACCEPT

#outgoing traceroute
#ip="your_main_IP"
iptables -A OUTPUT -p udp -s $ip --sport 1024:65535 -d 0/0 --dport 33434:33523 -j ACCEPT

#outgoing SMTP
#ip="your_main_IP"
iptables -A OUTPUT -p tcp -s $ip --sport 1024:65535 -d 0/0 --dport 25 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --sport 25 -d $ip --dport 1024:65535 -j ACCEPT

#outgoing FTP
#ip="your_main_IP"
iptables -A OUTPUT -p tcp -s $ip --sport 1024:65535 -d 0/0 --dport 21 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --sport 21 -d $ip --dport 1024:65535 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ip --sport 1024:65535 -d 0/0 --dport 1024:65535 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --sport 1024:65535 -d $ip --dport 1024:65535 -j ACCEPT

#outgoin SSH
#ip="your_main_IP"
iptables -A OUTPUT -p tcp -s $ip  --sport 513:65535 -d 0/0 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --sport 22 -d $ip --dport 513:65535 -j ACCEPT

#outgoin http and https
# for up2date and other stuff
#ip="your_main_IP"
iptables -A OUTPUT -p tcp -s $ip  --sport 1024:65535 -d 0/0 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --sport 80 -d $ip --dport 1024:65535 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ip  --sport 1024:65535 -d 0/0 --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --sport 443 -d $ip --dport 1024:65535 -j ACCEPT
# Okay Drop everything from here :D
iptables -A INPUT -s 0/0 -j DROP
iptables -A OUTPUT -d 0/0 -j DROP
# EOF SFW


