# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
[ -f /usr/local/nagios/bin/profile ] && . /usr/local/nagios/bin/profile


# User specific aliases and functions
if [[ $- != *i* ]] ; then #not interactive... don't need this file then
    return
fi
stty -ixon # disables ^s and ^q because they suck
set -o noclobber
shopt -s checkwinsize
shopt -s histappend 
shopt -s cdspell

export CVS_RSH="ssh"
export RSYNC_RSH="ssh"
export PAGER=less
export EDITOR=vim
export SVN_EDITOR=${EDITOR}
export PATH=~/bin:${PATH}:/sbin:/usr/sbin:/usr/local/nagios/libexec:/opt/nmap/bin:~/android/tools:/opt/jruby/bin
export PS1="[\u@\h]:\w \$ "
export CDPATH=".:~"
export MOZ_DISABLE_PANGO=1

alias l='ls -alF'
alias ll='ls -alF'
alias la='ls -Fa'
alias ld='ls -al -d * | egrep "^d"' # only subdirectories
alias lt='ls -alt | head -20' # recently changed files

alias watchtcp='watch -n 1 "sudo netstat -tpanl | grep ESTABLISHED"'
alias apt-get="sudo apt-get -y"
alias rpmqa='rpm -qa --queryformat "%{NAME}-%{VERSION}.%{RELEASE} (%{ARCH})\n"'
alias ibrpms="rpm -qa --queryformat='%{NAME}-%{VERSION} %{VENDOR}\n' | \
    grep 'Internet Broadcasting' | awk '{print \$1}'"
export TODAY=$(date +%d-%b-%Y)
alias phonehome="nohup ssh -f -N -R 10000:localhost:22 blutgens@us-admins.com"
alias unix2dos="perl -i -pe 's/\r//g'"
alias dos2unix="perl -i -pe 's/\n/\r\n/'"
alias ssh="ssh -X -A -t"
alias rsync="rsync -av --stats --progress"
alias myip="links -dump http://www.formyip.com/ | grep \"Your IP\" | \
    sed 's/^[ \t]*//'"
if [ $(uname) == "Linux" ] ; then
    complete -cf sudo
    alias du="du -sch"
    alias ls="ls --color"
    alias mv="mv -v"
    alias cp="cp -v"
    alias ln="ln -v"
    alias tar="tar -v"
    alias untar="tar -xvf"
    alias ll="ls -lh"
    alias la="ls -a"
    alias lla="ls -lah"
    alias rm="rm -v"
    alias more='less'
elif [ $(uname) == "SunOS" ] ; then
    alias ls="ls -F"
fi
alias cd..='cd ..'
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"


alias change_date='date +"%a %b %d %Y"'

alias rot13='perl -pe "y/n-za-mN-ZA-M/a-zA-Z/"'
alias scramble='perl -Mlocale -pe "s|\B\w+\B|join q(),sort{rand 2}$&=~/./g|ge"'
alias base64enc='perl -MMIME::Base64 -e "print encode_base64(join(q(),<>),q())"'
alias base64dec='perl -MMIME::Base64 -e "print decode_base64(join(q(),<>))"'
alias pmver="perl -le '\$m = shift; eval qq(require \$m) or die qq(module \"\$m\" is not installed\\n); print \$m->VERSION'"


#if [ $(hostname -s) == "splunk" ] ; then
#    export SPLUNK_HOME=/opt/splunk
#    export PATH="${SPLUNK_HOME}/bin:${PATH}"
#fi


# handy du
alias dux='du -sk ./* | sort -n | awk '\''BEGIN{ pref[1]="K"; pref[2]="M"; pref[3]="G";} { total = total + $1; x = $1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf("%g%s\t%s\n",int(x*10)/10,pref[y],$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf("Total: %g%s\n",int(total*10)/10,pref[y]); }'\'''

# Pimp Ass functions
lalias() {
    for i in aliases virtusertable ; do
        grep -i --color $1 /etc/mail/$i
    done
}
ppalias() {
      egrep ^${1} /etc/mail/aliases | tr ',' '\n' | \
           sed 's/^[ \t]*//;s/[ \t]*$//'
       }


cbust() {
    SEED="$$`date +%Y%m%e%k%M%S%N`"
    SEED=`echo $SEED | md5sum`
    CACHEBUSTER="${SEED:2:18}"
    GET -Sed ${1}?qs=${CACHEBUSTER}
}
    
# This one's pretty fucking dumb, but i'm keeping it so fuck off
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
		[ $RETVAL -eq 0 ] && break
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


#compare files using comm (requires perl) 
compare(){
      comm $1 $2 | perl -pe 's/^/1: /g;s/1: \t/2: /g;s/2: \t/A: /g;' | sort
  }

# remove an ssh key from known_hosts based on line number
nuke_ssh_key() {
    keynum=${1}
    sed -i -e "${keynum}d" ~/.ssh/known_hosts
}
# Don't particularly care of this when on a console
#if [ "$TERM" = "linux" ]; then
#    echo -en "\e]P0121212" #black
#    echo -en "\e]P8474747" #darkgrey
#    echo -en "\e]P1803232" #darkred
#    echo -en "\e]P9982b2b" #red
#    echo -en "\e]P25b762f" #darkgreen
#    echo -en "\e]PA89b83f" #green
#    echo -en "\e]P3AA9943" #dark yellow
#    echo -en "\e]PBefef60" #yellow
#    echo -en "\e]P4324c80" #darkblue
#    echo -en "\e]PC2b4f98" #blue
#    echo -en "\e]P55F5A90" #darkmagenta
#    echo -en "\e]PD826ab1" #magenta
#    echo -en "\e]P692b19e" #darkcyan
#    echo -en "\e]PEa1cdcd" #cyan
#    echo -en "\e]P7ffffff" #lightgrey
#    echo -en "\e]PFdedede" #white
#    clear #for background artifacting
#fi

# Keychain setup
    if [ -f ~/.ssh/id_dsa ] ; then
        keychain --nocolor -q id_dsa
        [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
        . $HOME/.keychain/$HOSTNAME-sh
        [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
        . $HOME/.keychain/$HOSTNAME-sh-gpg
    fi

alias bbq="netstat -ntu | awk '{print $5}' | grep -e ^[0-9] | cut -d: -f1 | sort | uniq -c | sort -n"

show_referrers() {
    # this shows all referrers sorted by top num of referrals 
    # needs an apache log as an argument
    if [ $# -ne 1 ] ; then
        echo "show_referrers <apache logfile>"
     else 
         echo "All referrers in $1 are:"
        grep -vE "boomshanka" $1 | awk '{print $11}' \
            | sort | uniq -c | sort -rn
    fi
}

show_all_requests() {
    # this shows a list of all requests sorted by most requested
    # You'll want to pipe this into less or head....
    # needs an apache log as an argument
    if [ $# -ne 1 ] ; then
        echo "show_all_requests <apache logfile>"
    else
        echo "All requests in $1 are:"
        grep -vE "boomshanka" $1| awk '{print $7}' | \
            sed 's/\/$//g' | sort | uniq -c | sort -rn
    fi
}
