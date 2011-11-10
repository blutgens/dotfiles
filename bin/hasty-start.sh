#!/bin/bash
echo "memcache"
ssh memcache1-int sudo service memcached start
echo "ZEOS"
ssh zeo1-int sudo /opt/zeo/control-all.sh start
echo "apics ams"
ssh apicsam1-int sudo service apcis-am start
ssh apicsam2-int sudo service apcis-am start
echo "shrm am"
ssh shrmam1-int sudo service shrm-am start
echo "ifma ams"
ssh ifmaam1-int sudo /opt/ifma-am/bin/instance1 start
ssh ifmaam2-int sudo /opt/ifma-am/bin/instance1 start
echo "prc"
ssh prc1-int sudo service prc start
ssh prc2-int sudo service prc start
echo "apics cscp"
ssh apicscscp1-int sudo service apics-cscp2012 start
ssh apicscscp2-int sudo service apics-cscp2012 start
ssh apicscscp3-int sudo service apics-cscp2012 start
echo "ifma fmp"
ssh ifmafmp1-int sudo /opt/ifma-fmp/bin/instance1 start
ssh ifmafmp2-int sudo /opt/ifma-fmp/bin/instance1 start
ssh ifmafmp3-int sudo /opt/ifma-fmp/bin/instance1 start

echo "ifma sfp"
ssh ifmasfp1-int sudo /opt/ifma-sfp/bin/control start
ssh ifmasfp2-int sudo /opt/ifma-sfp/bin/control start


