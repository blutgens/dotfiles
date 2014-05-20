# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
source ~/.bash_aliases
source ~/.bash_functions
source ~/.bash_prompt

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
#alias man="PAGER='most -s' man"
export EDITOR=vim
export SVN_EDITOR=${EDITOR}
export PATH=~/bin:${PATH}:/sbin:/usr/sbin:
#source ~/.bash_prompt
export CDPATH=".:~"

# GO Stuff
export GOPATH=${HOME}/gocode
export PATH=${PATH}:${GOPATH}/bin
if [ ! -d ${GOPATH} ] ; then
    mkdir -p ${GOPATH}/{bin,pkg,src}
fi



# Keychain setup
#if [ -f ~/.ssh/id_rsa ] ; then
#    keychain --nocolor -q id_rsa
#    [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
#    . $HOME/.keychain/$HOSTNAME-sh
#    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
#    . $HOME/.keychain/$HOSTNAME-sh-gpg
#fi

if [ -f ~/.liquidprompt/liquidprompt ]; then
    source ~/.liquidprompt/liquidprompt
fi
