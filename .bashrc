# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
source ~/.bash_aliases
source ~/.bash_functions
source ~/.bash_prompt
if [ $(hostname -s) != "LDCSRUN1" ] ; then
    source ~/.bash_ansible
fi
# User specific aliases and functions
if [[ $- != *i* ]] ; then #not interactive... don't need this file then
    return
fi
stty -ixon # disables ^s and ^q because they suck
set +o noclobber
shopt -s checkwinsize
shopt -s histappend 
shopt -s cdspell

export CVS_RSH="ssh"
export RSYNC_RSH="ssh"
export PAGER=less
#alias man="PAGER='most -s' man"
export EDITOR=vim
export SVN_EDITOR=${EDITOR}
export PATH=~/bin:${PATH}:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin
if [ -d /opt/Navisphere/bin/ ] ; then
    export PATH=${PATH}:/opt/Navisphere/bin
fi
export CDPATH=".:~"

export TERM=xterm
# GO Stuff
export GOPATH=${HOME}/gocode
export PATH=${PATH}:${GOPATH}/bin
if [ ! -d ${GOPATH} ] ; then
    mkdir -p ${GOPATH}/{bin,pkg,src}
fi
export MAN_POSIXLY_CORRECT=true

export JAVA_HOME=/usr/java/latest
export JRE_HOME=${JAVA_HOME}
if [ -d /opt/Navisphere/bin ] ; then
    export PATH=${PATH}:/opt/Navisphere/bin
fi

export CFLAGS="-Wall"

# Keychain setup
if [ ${HOSTNAME} = "ldcsrun1" ] ; then

    if [ -f ~/.ssh/id_rsa ] ; then
        keychain --nocolor -q id_rsa
        [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
        . $HOME/.keychain/$HOSTNAME-sh
        [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
        . $HOME/.keychain/$HOSTNAME-sh-gpg
    fi
fi

if [ -x ~/bin/vcprompt ]; then
    export PS1='\u@\h:\w $(vcprompt):\$ '
fi
