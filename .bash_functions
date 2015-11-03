push-key() {
    ssh-copy-id -i ~/.ssh/id_rsa.pub $1
}
push-configs() {
    scp dotfiles/.{du-excludes,rpmmacros} $1:
    scp dotfiles/.profile-cp $1:.profile
}

push-all(){
    SERVER=${1}
    push-key ${SERVER}
    push-configs $SERVER
}

zombie() {
    ps aux | awk '$8=="Z" { print $2 }'
}

backup-home(){
    rsync -auv  --delete-excluded --exclude-from=.rsync-exclude \
        --delete --progress --stats /home/blutgens ${1}
}

qf2s(){
    rpm -ql $(rpm -qf $1)|grep -P "\.service";
}

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

lsof-du()
{
    lsof -ns | grep "\<REG\>.* (deleted)$" | \
        awk '{a[$1]+=$7;b[$1]++;}END{for(i in a){printf\
        ("%s %d %.2f MB\n", i,b[i],a[i]/1048576);}}' | \
        column -t | sort -k3 -n
}
show-ami-luns() {
    if [ $# -ne 1 ] ; then
        echo "You need to supply a search string e.g. i10ctrl."
    else
        naviseccli -h 172.17.99.4 lun -list | awk -F" " "/Name:/ && /LUN/ && /${1}/"
    fi
}

show-ami-lun-verbose() {
    if [ $# -ne 1 ] ; then
        echo "Please specify lun number"
    else
        naviseccli -h 172.17.99.4 lun -list -l ${1}
    fi
}

show-snap-session() {
    if [ $# -ne 1 ] ; then
        naviseccli -h 172.17.99.4 snapview -listsessions -all | \
             awk -F":  " "/^Name/"'{print $2}' | sort
    else
        naviseccli -h 172.17.99.4 snapview -listsessions -all | \
            awk -F":  " "/^Name/ && /${1}/"'{print $2}' | sort
    fi
}

start-snap-session() {
    echo -n "Enter in the session name: "
    read SESSION
    echo -n "Enter in a space separated list of luns: "
    read LUNS
    
     /opt/Navisphere/bin/naviseccli -h 172.17.99.4 snapview \
         -startsession ${SESSION} \
         -lun ${LUNS}

}

stop-snap-session() {
    if [ $# -ne 1 ]; then
        echo -n "Enter in the session name: "
        read SESSION
    else
        SESSION=${1}
     /opt/Navisphere/bin/naviseccli -h 172.17.99.4 snapview \
         -stopsession ${SESSION}

    fi

}


grow-vnx-lun() {
    if [ $# -ne 2 ] ; then
        echo "Enter a Lun number and a size in gigabytes to proceed"
    else
        naviseccli -h 172.17.99.4 lun -expand -l $1 -capacity $2 -sq gb
    fi
}

show-vnx-pool-names() {
    naviseccli -h 172.17.99.4 storagepool -list | awk -F ": " "/Pool Name/"'{print $2}'
}

show-vnx-pool-ids() {
    for i in `show-vnx-pool-names` ; do
        echo $i
    done
}


show-vnx-pool-free() {
    NAME=${1}
    echo ${NAME}
    naviseccli -h 172.17.99.4 storagepool -list -name  \'${NAME}\"
}

ldap-search() {
    ldapsearch -h cpr.ca -D \
        "CN=Benjamin Lutgens,OU=Users,OU=EDS,DC=cpr,DC=ca" -W \
        -b "dc=cpr,dc=ca" $1
}



# vim:set ft=sh:
