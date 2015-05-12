memstats() {
    PROCNAME=${1}
    if [ ${PROCNAME} ] ; then
        pgrep ${PROCNAME} | xargs -rI{} grep -H VmHWM /proc/{}/status
    else
        echo "You need to provide a search string, dummy."
        echo 'FAIL!!!!'
    fi
}

numlines () {
    awk '{print NR": "$0 }' < $1
}

function thist
{
    if [[ "${HISTFILE+defined}" ]]
    then
        _HISTFILE="$HISTFILE"
        unset HISTFILE
        history -c
    else
        history -c
        HISTFILE="$_HISTFILE"
        unset _HISTFILE
    fi
}

# For when you're on a lame commercial unix box w/o gnu sed
psed () {
    perl -pi -e "s:${1}:${2}:g" $3

}

# FFS I'm lazy
showpath () {
    echo $PATH | tr ':' '\n'
}

cycle_kill () {
# Used by the really_kill function below
    PID=$1
    RETVAL=0

    for signal in "TERM" "INT" "HUP" "KILL"; do
    kill -$signal $PID
    RETVAL=$?
    $RETVAL -eq 0 ] && break
    echo "warning: kill failed: pid=$PID, signal=$signal" >&2
    sleep 1
    done

    return $RETVAL
}

reallykill () {
    # Feed it a PID or the ouput of 'pgrep'
    for pid in "$@" ; do
        cycle_kill $pid
    done
}

#compare files using comm (requires perl)⋅
compare(){
      comm $1 $2 | perl -pe 's/^/1: /g;s/1: \t/2: /g;s/2: \t/A: /g;' | sort
  }


function nwm-fix() {
    sudo sed -i -e 's:system-ca-certs=true:system-ca-certs=false:g' /etc/NetworkManager/system-connections/$1
}

function pingdef() {
    ping $(ip route show |awk ' /^default/ {print $3}')
}

fileinfo() { 
    RPMQF=$(rpm -qf $1); 
    RPMQL=$(rpm -ql $RPMQF);
    echo "man page:";
    whatis $(basename $1); 
    echo "Services:"; 
    echo -e "$RPMQL\n"|grep -P "\.service";
    echo "Config files:";
    rpm -qc $RPMQF;
    echo "Provided by:" $RPMQF; 
}

# vim:set ft=sh:
