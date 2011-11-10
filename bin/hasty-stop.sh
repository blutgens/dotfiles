#!/bin/bash

echo "apics cscp"
ssh apicscscp1-int sudo service apics-cscp2012 stop
ssh apicscscp2-int sudo service apics-cscp2012 stop
ssh apicscscp3-int sudo service apics-cscp2012 stop
echo "ifma fmp"
ssh ifmafmp1-int sudo /opt/ifma-fmp/bin/instance1 stop
ssh ifmafmp2-int sudo /opt/ifma-fmp/bin/instance1 stop
ssh ifmafmp3-int sudo /opt/ifma-fmp/bin/instance1 stop

echo "ifma sfp"
ssh ifmasfp1-int sudo /opt/ifma-sfp/bin/control stop
ssh ifmasfp2-int sudo /opt/ifma-sfp/bin/control stop

echo "apics ams"
ssh apicsam1-int sudo service apcis-am stop
ssh apicsam2-int sudo service apcis-am stop
echo "shrm am"
ssh shrmam1-int sudo service shrm-am stop
echo "ifma ams"
ssh ifmaam1-int sudo /opt/ifma-a:w
m/bin/instance1 stop
ssh ifmaam2-int sudo /opt/ifma-am/bin/instance1 stop
echo "prc"
ssh prc1-int sudo service prc stop
ssh prc2-int sudo service prc stop

ssh zeo1-int sudo /opt/zeo/control-all-stop

echo "memcache"
ssh memcache1-int sudo service memcached stop
