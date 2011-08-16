# Pimp Ass functions
lalias() {
    for i in aliases virtusertable ; do
        grep -i --color $1 /etc/mail/$i
    done
}

numlines () {
    awk '{print NR": "$0 }' < $1
}


# For when you're on a lame ass commercial unix box w/o gnu sed
psed () {
    perl -pi -e "s:${1}:${2}:g" $3

}

# Fuck sake I'm lazy
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

# remove an ssh key from known_hosts based on line number
nuke_ssh_key() {
    keynum=${1}
    sed -i -e "${keynum}d" ~/.ssh/known_hosts
}













# set ft=bash
