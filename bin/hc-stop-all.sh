#!/bin/bash
APICS_AMS="apicsam1 apicsam2"
IFMA_AMS="ifmaam1 ifmam2"
SHRM_AMS="shrmam1"
PRC="prc1 prc2"
APICS_LC="apicscscp1 apicscscp2 apicscscp3"
IFMA_FMP="ifmafmp1 ifmafmp2 ifmafmp3"
IFMASFP="ifmasfp1 ifmasfp2"
SHRM_LS2012="shrmls1 shrmls2 shrmls3"

hc_do() {
    PARTNER="$1"
    COMMAND="$2"
    for i in $1 ; do
        ssh ${PARTNER}-int ${COMMAND}
    done
}


