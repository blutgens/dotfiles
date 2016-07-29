#!/bin/bash

#This script was created to make it easier to register systems against the 3m Satellite Server.
echo "DO NOT RUN THIS ON THE SATELLITE SERVERS!!!!"
echo -n "Please enter the location i.e. (277, 243, dist) "
read building

echo -n "Please enter the environment (dev, qa, prd) "
read enviro

echo -n "What year & quarter do you want? (i.e. 4q2007) "
read quarter

echo -n "Is this a node in a linux cluster? (y or n) "
read cluster

if [ "$cluster" = "y" ]; then
 clust="clu.sh"
else
 clust="std.sh"
fi

#Get the version
version=$(cat /etc/redhat-release |cut -d' ' -f5)

if [ "$version" = "ES" ]; then
ver="es"
else
ver="as"
fi

#Get the arch
arch=$(uname -i)
if [ "$arch" = "i386" ]; then
arch="x86"
else
arch="x64"
fi

#Create the key script name string
scriptname=$(echo $building$enviro-$quarter-4$arch$ver-$clust)

echo -n "The following script will be used: $scriptname Is this correct? (y or n)"
read proceed

if [ "$proceed" = "y" ]; then
wget -qO- http://rhbuild.mmm.com/pub/bootstrap/noupdate/$scriptname | /bin/bash
else
 echo "Then we are going to exit!" 
 exit 0;
fi
