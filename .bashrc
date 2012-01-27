# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
[ -f /usr/local/nagios/bin/profile ] && . /usr/local/nagios/bin/profile
source ~/.bash_aliases
source ~/.bash_functions

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
alias man="PAGER='most -s' man"
export EDITOR=vim
export SVN_EDITOR=${EDITOR}
export PATH=~/bin:${PATH}:/sbin:/usr/sbin:/usr/local/nagios/libexec::~/android/tools:/opt/jruby/bin
source ~/.bash_prompt
export CDPATH=".:~"




# Keychain setup
#if [ -f ~/.ssh/id_rsa ] ; then
#    keychain --nocolor -q id_rsa
#    [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
#    . $HOME/.keychain/$HOSTNAME-sh
#    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
#    . $HOME/.keychain/$HOSTNAME-sh-gpg
#fi


